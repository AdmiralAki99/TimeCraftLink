//
//  PlaylistDetails.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-15.
//

import Foundation

struct PlaylistDetails : Codable {
    
    let collaborative : Bool
    
    let description : String
    
    let external_urls : [String : String]
    
    let id : String
    
    let images : [SpotifyAPIImage]
    
    let name : String
    
    let owner : Owner
    
    let `public` : Bool
    
    let tracks : PlaylistDetailsTracks
}

struct PlaylistDetailsTracks : Codable{
    
    let limit : Int
    
    let total : Int
    
    let offset : Int
    
    let items : [PlaylistTracksDetails]
    
    
}

struct PlaylistTracksDetails : Codable{
    
//    let added_at : String
//
//    let added_by : AddedByDetails
//
//    let is_local : Bool
//
//    let track : PlaylistTrack
    
    let track : Track
    
}

struct PlaylistTrack : Codable{
    
    let album : Album
    
    let artists : [Artist]
    
    let available_markets : [String]
    
    let disc_number : Int
    
    let duration_ms : Int
    
    let explicit : Bool
    
    let external_ids : [String : String]
    
    let external_urls : [String : String]
    
    let id : String
    
    let is_playable : Bool
    
    
    
    
}

struct AddedByDetails : Codable{
    
    let external_urls : [String : String]
    
//    let followers : Followers
    
    let id : String
    
    let type : String
    
    let uri : String
}
