//
//  AlbumDetails.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-15.
//

import Foundation

struct AlbumDetails : Codable{

    let album_type : String
    
    let artists : [Artist]
    
    let available_markets : [String]
    
    let copyrights : [[String:String]]
    
    let external_urls : [String : String]

    let id : String

    let images : [SpotifyAPIImage]

    let label : String

    let name : String

    let popularity : Int

    let release_date : String

    let total_tracks : Int

    let tracks : TracksResponse
    
}

struct TracksResponse : Codable {
    let items : [AlbumDetailsTrack]
}

struct AlbumDetailsTrack : Codable{
    let artists : [Artist]
    
    let available_markets : [String]
    
    let disc_number : Int
    
    let duration_ms : Int
    
    let explicit: Bool
    
    let external_urls : [String : String]
    
    let id : String
    
    let name : String
}




