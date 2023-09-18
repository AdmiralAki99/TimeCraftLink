//
//  ActiveDevice.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-29.
//

import Foundation

struct SpotifyActiveDevice: Codable{
    let devices : [SpotifyDevice]
}

struct SpotifyDevice : Codable{
    let id : String
    let is_active : Bool
    let is_private_session : Bool
    let is_restricted : Bool
    let name : String
    let supports_volume : Bool
    let type : String
    let volume_percent : Int
}
