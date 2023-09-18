//
//  User.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import Foundation

struct User : Codable{
    let country : String
    
    let display_name : String
    
    let email: String
    
    let explicit_content : [String: Bool]
//
    let external_urls : [String: String]
//
    let href : String
//
    let id : String
//
    let images : [UserProfileImage]

    let product : String
//
    let type: String
//
    let uri: String
}

struct UserProfileImage : Codable{
    let url: String
}

//{
//    country = IN;
//    "display_name" = "Akhilesh Warty";
//    email = "wartyakhilesh@gmail.com";
//    "explicit_content" =     {
//        "filter_enabled" = 0;
//        "filter_locked" = 0;
//    };
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/user/g9a2afr2b4a33rcv10xaiegrs";
//    };
//    followers =     {
//        href = "<null>";
//        total = 2;
//    };
//    href = "https://api.spotify.com/v1/users/g9a2afr2b4a33rcv10xaiegrs";
//    id = g9a2afr2b4a33rcv10xaiegrs;
//    images =     (
//    );
//    product = premium;
//    type = user;
//    uri = "spotify:user:g9a2afr2b4a33rcv10xaiegrs";
//}
