//
//  NewReleases.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import Foundation

struct NewReleases : Codable{
    let albums : AlbumsResponse
}

struct AlbumsResponse : Codable{
    let items: [Album]
}
