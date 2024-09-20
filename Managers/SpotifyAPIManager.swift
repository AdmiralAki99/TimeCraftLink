//
//  SpotifyAPIManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import Foundation

final class SpotifyAPIManager : ObservableObject{
    static let api_manager = SpotifyAPIManager()
    
    static var device_id = ""
    
    private init(){
        // Should Authenticate
        // Store Active Device if any
        self.getAvailableDevices { resp in
            
        }
        // Store Current Playback State
    }
    
    @Published var currentTrack : Track?
    @Published var currentProgress : Int = 0
    /*
     MARK: General API
     */
    
    struct API{
        static let apiURL = "https://api.spotify.com/v1"
    }
    
    /*
     MARK: API Response
     */
    
    enum APIResponseError : Error{
        case FailedToGetData
        case NoActiveSpotifyPlayer
    }
    
    enum HTTPRequest : String{
        case GET
        case POST
        case PUT
    }
    
    
    /*
     MARK: API Calls
     */
    
    
    func getAlbumDetails(for album:Album, completion: @escaping (Result<AlbumDetails,Error>) -> Void){
        //        print("Decoding Data")
        createRequest(with: URL(string: API.apiURL + "/albums/\(album.id)"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    let data = try JSONDecoder().decode(AlbumDetails.self, from: data)
                    
                    completion(.success(data))
                }catch{
                    print("Get Album Details")
                    print(err?.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(with url: URL?, request_type: HTTPRequest, completion: @escaping (URLRequest) -> Void){
        Authentication.auth.validToken { token in
            guard let spotifyAuthURL = url else{
                return
            }
            var authRequest = URLRequest(url: spotifyAuthURL)
            authRequest.httpMethod = request_type.rawValue
            authRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completion(authRequest)
        }
    }
    
    public func getAvailableDevices(completion: @escaping ((Result<SpotifyActiveDevice,Error>)-> Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/devices"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    
                    //                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //
                    //                    print(json)
                    
                    let data = try JSONDecoder().decode(SpotifyActiveDevice.self, from: data)
                    completion(.success(data))
                    
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
        
    }
    
    func getCurrentlyPlayingTrack(completion: @escaping((Result<CurrentPlayingTrack,Error>)-> Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/currently-playing"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    //                    let data = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    //
                    //                    print(data)
                    let data = try JSONDecoder().decode(CurrentPlayingTrack.self, from: data)
                    DispatchQueue.main.async{
                        self.currentTrack = data.item
                    }
                    completion(.success(data))
                    
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //todo: Implement Pause Playback Function
    
    func pauseSpotifyPlayback(completion: @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/pause?"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                print(response)
            }
            task.resume()
        }
    }
    //todo: Implement Play/Resume Playback Function
    
    func playSpotifyPlayback(completion: @escaping((Result<String,Error>)-> Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/play?"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                print(response)
            }
            task.resume()
        }
    }
    
    //todo: Implement Forward Playback Function
    
    func forwardSpotifyPlayback(completion : @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/next?"), request_type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print(data)
            }
            task.resume()
        }
    }
    
    //todo: Implement Rewind Playback Function
    
    func rewindSpotifyPlayback(completion : @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/previous?"), request_type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print(data)
            }
            task.resume()
        }
    }
    
    func seekToPositionSpotifyPlayback(with seek_position: Int, device_id: String,completion : @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/seek?position_ms=\(seek_position)"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
            }
            task.resume()
        }
    }
    
    func togglePlaybackShuffle(completion: @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/shuffle?"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, resp, err in
                print(data)
                print(err)
            }
            task.resume()
        }
    }
    
    func toggleRepeatPlayback(completion: @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/repeat?"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, resp, err in
                print(data)
                print(err)
            }
            task.resume()
        }
    }
    
    //todo: Get Playback State
    
    func getPlaybackState(completion: @escaping((Result<CurrentPlaybackState,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                guard let data = data, err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                let httpStatus = (response as! HTTPURLResponse).statusCode
                
                do{
                    if(httpStatus == 200){
                        let data = try JSONDecoder().decode(CurrentPlaybackState.self, from: data)
                        DispatchQueue.main.async {
                            self.currentProgress = data.progress_ms ?? 0
                        }
                       
                        completion(.success(data))
                    } else if(httpStatus == 204){
                        completion(.failure(APIResponseError.NoActiveSpotifyPlayer))
                    }
                    
                    
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    func play(){
        
    }
    
    func pause(){
        
    }
    
    func skip(){
        
    }
    
    func rewind(){
        
    }
    
    func toggleRepeat(){
        
    }
    
    func toggleShuffle(){
        
    }
    
    func getCurrentSeekPercentage() -> Float{
        return (Float(self.currentProgress)/Float(self.currentTrack?.duration_ms ?? 0))
    }
    
    
}
