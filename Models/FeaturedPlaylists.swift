//
//  FeaturedPlaylists.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import Foundation

struct FeaturedPlaylists : Codable{
    let message : String
    
    let playlists: PlaylistAPIResponse
}

struct PlaylistAPIResponse : Codable{
    let items : [Playlist]
}
