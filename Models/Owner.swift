//
//  Owner.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import Foundation

struct Owner : Codable{
    let display_name : String
    
    let external_urls : [String : String]
    
    let id : String
    
    let type: String
    
    let uri : String
}
