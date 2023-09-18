//
//  Artist.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import Foundation

struct Artist : Codable{
    let id : String
    
    let name : String
    
    let type: String
    
    let uri : String

    let external_urls : [String : String]
    
}
