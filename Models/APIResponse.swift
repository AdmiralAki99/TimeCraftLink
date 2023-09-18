//
//  APIResponse.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-11.
//

import Foundation

struct APIResponse : Codable {
    
    let access_token: String
    
    let expires_in : Int
    
    let refresh_token : String?
    
    let scope : String
    
    let token_type: String
    
}
