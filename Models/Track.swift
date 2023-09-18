//
//  Track.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import Foundation

struct Track : Codable{
    let album : Album?
    
    let artists : [Artist]
    
    let available_markets : [String]
    
    let disc_number : Int
    
    let duration_ms : Int
    
    let explicit : Bool
    
    let external_ids : [String : String]
    
    let id : String
    
    let name : String
    
    let popularity : Int
    
    let uri : String
    
    
}
