//
//  Album.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import Foundation

struct Album : Codable{
    let album_type: String
    
    let available_markets : [String]
    
    let id : String
    
    let images : [SpotifyAPIImage]
    
    let name: String
    
    let release_date : String
    
    let total_tracks : Int
    
    let artists : [Artist]
    
    
}
