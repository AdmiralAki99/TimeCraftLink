//
//  SpotifyAPIManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import Foundation

final class SpotifyAPIManager{
    static let api_manager = SpotifyAPIManager()
    
    static var device_id = ""
    private init(){
        
    }
    
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
    
    public func getFeaturedPlaylistsFromAlbum(with album: Album,completion: @escaping ((Result<RecommendedPlaylists,Error>) -> Void)){
        createRequest(with: URL(string: API.apiURL + "/recommendations?limit=6&seed_artists=\(album.artists.first?.id ?? "")"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                do{
                    
//                    let data = try  JSONSerialization.jsonObject(with: data,options: .allowFragments)
//
//                    print(data)
                    
                    let recommended_playlists = try JSONDecoder().decode(RecommendedPlaylists.self, from: data)
                    completion(.success(recommended_playlists))
                }catch{
                    print("Get Featured Playlists From Album")
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
            
            task.resume()
        }
    }
    
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
    
    func getPlaylistsDetails(for playlist:Playlist, completion: @escaping (Result<PlaylistDetails,Error>) -> Void){
        createRequest(with: URL(string: API.apiURL + "/playlists/\(playlist.id)"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data, err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    let data = try JSONDecoder().decode(PlaylistDetails  .self, from: data)
                    
                    completion(.success(data))
                }catch{
                    print("Get Playlist Details")
                    completion(.failure(error))
                    print(err?.localizedDescription)
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
    
    public func getRecommendations(genres: Set<String>,completion: @escaping ((Result<Recommendations,Error>) -> Void)){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: API.apiURL + "/recommendations?limit=50&seed_genres=\(seeds)"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data, err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
//                    let data = try  JSONSerialization.jsonObject(with: data,options: .allowFragments)
//
//                    print(data)
                    
                    let data = try JSONDecoder().decode(Recommendations.self, from: data)
                    
                    completion(.success(data))
                }catch{
                    print("Get Recommendations")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendationGenres(completion: @escaping ((Result<RecommendationGenres,Error>)-> Void)){
        createRequest(with: URL(string: API.apiURL + "/recommendations/available-genre-seeds"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    let data = try JSONDecoder().decode(RecommendationGenres.self, from: data)
                    
                    completion(.success(data))
                }catch{
                    print("Get Recommendation Genres")
                    completion(.failure(error))
                    print(err?.localizedDescription)
                }
            }
            task.resume()
        }
        
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylists,Error>) -> Void)){
        createRequest(with: URL(string: API.apiURL + "/browse/featured-playlists?limit=50"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
//                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//
//                    print(json)
//                    
                    let featured_playlists = try JSONDecoder().decode(FeaturedPlaylists.self, from: data)
                    completion(.success(featured_playlists))
                }catch{
                    print("Get Featured Playlists")
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getNewReleases(completion: @escaping ((Result<NewReleases,Error>) -> Void)){
        createRequest(with: URL(string: API.apiURL + "/browse/new-releases?limit=50"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    let new_releases = try JSONDecoder().decode(NewReleases.self,from: data)
                    
//                    let data = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//
//                    print(data)
                    
                    completion(.success(new_releases))
                }catch{
                    print("Get New Releases")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getLikedSongs(with offset: Int , completion: @escaping (Result<String,Error>) -> Void){
        createRequest(with: URL(string: "\(API.apiURL)/me/tracks?limit=1&offset=\(offset)"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)

                    print(json)
                    
//                    let data = try JSONDecoder().decode(LikedSongs.self, from: data)
//
//                    print(data)
                }catch{
                    print(err?.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    public func getCategories(completion: @escaping (Result<[CategoryInfo],Error>)-> Void){
        createRequest(with: URL(string: "\(API.apiURL)/browse/categories?limit=50"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    let data = try JSONDecoder().decode(Categories.self, from: data)
                    
                    completion(.success(data.categories.items))
                    
                }catch{
                    print("Get Categories")
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(with category : CategoryInfo,completion: @escaping (Result<[Playlist],Error>)-> Void){
        createRequest(with: URL(string: "\(API.apiURL)/browse/categories/\(category.id)/playlists?limit=50"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
                    let data = try JSONDecoder().decode(CategoryPlaylist.self, from: data)
                    completion(.success(data.playlists.items))
                }catch{
                    print("Get Category Playlists")
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    public func getUserProfile(completion: @escaping (Result<User,Error>)->Void){
//        print("Getting User Profile")
        createRequest(with: URL(string: API.apiURL + "/me"), request_type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data, err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    print("Error")
                    return
                }
                do{
                    let userProfile = try JSONDecoder().decode(User.self, from: data)
                    print(userProfile)
                    completion(.success(userProfile))
                    
//                    let json_data = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//
//                    print(json_data)
                }catch{
                    print("Get User Profile")
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func searchSpotify(with query_string : String, completion: @escaping (Result<[SearchResult],Error>)->Void){
        createRequest(with: URL(string: "\(API.apiURL)/search?type=album,artist,track,playlist&q=\(query_string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), request_type: .GET) { request in
            print(request.url?.absoluteURL ?? "-"  )
            let task = URLSession.shared.dataTask(with: request) { data, _, err in
                guard let data = data , err == nil else{
                    completion(.failure(APIResponseError.FailedToGetData))
                    return
                }
                
                do{
//                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//
//                    print(json)
                    let data = try JSONDecoder().decode(SpotifySearchResult.self, from: data)
                    var results: [SearchResult] = []
                    results.append(contentsOf: data.tracks.items.compactMap({.Track(object: $0)}))
                    results.append(contentsOf: data.albums.items.compactMap({.Album(object: $0)}))
                    results.append(contentsOf: data.artists.items.compactMap({.Artist(object: $0)}))
                    results.append(contentsOf: data.playlists.items.compactMap({.Playlist(object: $0)}))
                    completion(.success(results))
                }catch{
                    
                }
            }
            task.resume()
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
    
    func pauseSpotifyPlayback(with device_id: String,completion: @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/pause?device_id=\(device_id)"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                print(response)
            }
            task.resume()
        }
    }
    //todo: Implement Play/Resume Playback Function
    
    func playSpotifyPlayback(with device_id: String,completion: @escaping((Result<String,Error>)-> Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/play?device_id=\(device_id)"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                print(response)
            }
            task.resume()
        }
    }
    
    //todo: Implement Forward Playback Function
    
    func forwardSpotifyPlayback(with device_id: String,completion : @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/next?device_id=\(device_id)"), request_type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print(data)
            }
            task.resume()
        }
    }
    
    //todo: Implement Rewind Playback Function
    
    func rewindSpotifyPlayback(with device_id: String,completion : @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/previous?device_id=\(device_id)"), request_type: .POST) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print(data)
            }
            task.resume()
        }
    }
    
    func seekToPositionSpotifyPlayback(with seek_position: Int, device_id: String,completion : @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/seek?position_ms=\(seek_position)&device_id=\(device_id)"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in

            }
            task.resume()
        }
    }
    
    func togglePlaybackShuffle(with shuffleState: String,spotifyDeviceID: String,completion: @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/shuffle?state=\(shuffleState)&device_id=\(spotifyDeviceID)"), request_type: .PUT) { request in
            let task = URLSession.shared.dataTask(with: request) { data, resp, err in
            }
            task.resume()
        }
    }
    
    func toggleRepeatPlayback(with shuffleState: String,spotifyDeviceID: String,completion: @escaping((Result<String,Error>)->Void)){
        createRequest(with: URL(string: "\(API.apiURL)/me/player/repeat?state=\(shuffleState)&device_id=\(spotifyDeviceID)"), request_type: .PUT) { request in
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
    
    
}
