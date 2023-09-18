//
//  Category.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-23.
//

import Foundation

struct Categories : Codable{
    let categories : Category
}

struct Category: Codable{
    let items : [CategoryInfo]
}

struct CategoryInfo : Codable {
    let icons : [CategoryIcon]
    let id : String
    let name : String
}

struct CategoryIcon : Codable{
    let url : String
}
