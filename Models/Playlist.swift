//
//  Playlist.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import Foundation

struct Playlist : Codable{
    let description: String
    
    let external_urls : [String: String]
    
    let id: String
    
    let images : [SpotifyAPIImage]
    
    let name : String
    
    let owner : Owner
}
