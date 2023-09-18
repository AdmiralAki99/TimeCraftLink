//
//  SpotifySearchResult.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-26.
//

import Foundation

struct SpotifySearchResult : Codable{
    let tracks : SearchTrack
    
    let artists : SearchArtist
    
    let albums : SearchAlbum
    
    let playlists : SearchPlaylist
    
    
}

struct SearchTrack : Codable{
    let items : [Track]
}

struct SearchArtist: Codable{
    let items : [Artist]
}

struct SearchAlbum : Codable{
    let items : [Album]
}

struct SearchPlaylist : Codable{
    let items : [Playlist]
}

enum SearchResult{
    case Artist(object: Artist)
    case Album(object: Album)
    case Playlist(object: Playlist)
    case Track(object: Track)
}
