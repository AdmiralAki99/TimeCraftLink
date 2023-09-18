//
//  LoginManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import Foundation

class Authentication{
    
    /*
     MARK: Spotify Client
     */
    
    struct Client{
        static let id = "1518efa088954d2f8e4ae240890bf5c7"
        static let secret = "9dabf32b10a646b0b499e05916b0929d"
        static let redirect_url = "http://localhost/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email%20user-read-playback-state%20user-read-currently-playing%20user-modify-playback-state"
    }
    
    struct SpotifyAPI{
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    /*
    // MARK: - Attributes & Variables
    */
    
    // Only having one authentication object throughout the app
    /*
     MARK: Shared Authentication
     */
    static let auth = Authentication()
    
    private var authenticationToken: String?{
        return nil
    }
    
    private var refreshToken: String?{
        return nil
    }
    
    var signedIn: Bool{
        return access_token != nil
    }
    
    private var access_token: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refresh_token: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var expiration_date: Date?{
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    private var needsRefreshing: Bool{
        guard let expiration_date = expiration_date else{
            return false
        }
        
        let currentDateTime = Date()
        return currentDateTime.addingTimeInterval(TimeInterval(300)) >= expiration_date
    }
    
    public var loginURL: URL?{
       
        let base_url = "https://accounts.spotify.com/authorize"
        let requestString = "\(base_url)?response_type=code&client_id=\(Client.id)&scope=\(Client.scopes)&redirect_uri=\(Client.redirect_url)&show_dialog=TRUE"
        
        return URL(string: requestString)
    }
    
    private var refreshingToken = false
    
    
    private var ongoingRefreshBlocks = [((String) -> Void)]()
    
    /*
     // MARK: Methods & Functions
     */
    
    private init(){
        
    }
    
    /*
     MARK: Spotify API Calls
     */
    
    func refreshAccessToken(completion: ((Bool) -> Void)?){
        guard !refreshingToken else{
           return
        }
        
        guard needsRefreshing else{
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refresh_token else{
            return
        }
        
        guard let spotifyAPIURL = URL(string: SpotifyAPI.tokenAPIURL)else{
            return
        }
        
        refreshingToken = true
        
        var queryComponents = URLComponents()
        queryComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var apiCall = URLRequest(url: spotifyAPIURL)
        apiCall.httpMethod = "POST"
        apiCall.httpBody = queryComponents.query?.data(using: .utf8)
        apiCall.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var authHeaderString = Client.id + ":" + Client.secret
        var authHeaderData = authHeaderString.data(using: .utf8)
        guard let encodedAuthHeaderString = authHeaderData?.base64EncodedString() else{
            completion?(false)
            print("BASE 64 Encoding AUTH HEADER FAILED")
            return
        }
        apiCall.setValue("Basic \(encodedAuthHeaderString) ", forHTTPHeaderField: "Authorization")
         let webCall = URLSession.shared.dataTask(with: apiCall) { [weak self] data, _, err in
             self?.refreshingToken = false
            guard let data = data,err == nil else{
                completion?(false)
                return
            }
             
             do{
                 let response = try JSONDecoder().decode(APIResponse.self, from: data)
                 self?.cacheAccessToken(response: response)
//                 let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//                 print("API RESPONSE: \(json)")
                 print("Refresh Success")
                 self?.ongoingRefreshBlocks.forEach { $0(response.access_token)}
                 self?.ongoingRefreshBlocks.removeAll()
                 completion?(true)
             }catch {
                 completion?(false)
                 print(err?.localizedDescription)
             }
        }
        
        webCall.resume()
    }
    
    
    func cacheAccessToken(response: APIResponse){
        UserDefaults.standard.setValue(response.access_token, forKey: "access_token")
        
        if let refresh_token = response.refresh_token{
            UserDefaults.standard.setValue(refresh_token, forKey: "repsonse_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(response.expires_in)), forKey: "expiration_date")
    }
    
    public func validToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else{
            ongoingRefreshBlocks.append(completion)
            return
        }
        if needsRefreshing{
            refreshAccessToken { success in
                if success{
                    if let token = self.access_token, success{
                        completion(token)
                    }
                }
            }
        }else if let token = access_token {
            completion(token)
        }
    }
    
    func generateToken(code:String,completion: @escaping ((Bool) -> Void)){
        guard let spotifyAPIURL = URL(string: SpotifyAPI.tokenAPIURL)else{
            return
        }
        
        var queryComponents = URLComponents()
        queryComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Client.redirect_url)
        ]
        
        var apiCall = URLRequest(url: spotifyAPIURL)
        apiCall.httpMethod = "POST"
        apiCall.httpBody = queryComponents.query?.data(using: .utf8)
        apiCall.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var authHeaderString = Client.id + ":" + Client.secret
        var authHeaderData = authHeaderString.data(using: .utf8)
        guard let encodedAuthHeaderString = authHeaderData?.base64EncodedString() else{
            completion(false)
            print("BASE 64 Encoding AUTH HEADER FAILED")
            return
        }
        apiCall.setValue("Basic \(encodedAuthHeaderString) ", forHTTPHeaderField: "Authorization")
         let webCall = URLSession.shared.dataTask(with: apiCall) { [weak self] data, _, err in
            guard let data = data,err == nil else{
                completion(false)
                return
            }
             
             do{
                 let response = try JSONDecoder().decode(APIResponse.self, from: data)
                 self?.cacheAccessToken(response: response)
//                 let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//                 print("API RESPONSE: \(json)")
                 completion(true)
             }catch {
                 completion(false)
                 print(err?.localizedDescription)
             }
        }
        
        webCall.resume()
    }
}
