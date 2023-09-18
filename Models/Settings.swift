//
//  Settings.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import Foundation

struct Section{
    let title: String
    let options : [Option]
}

struct Option{
    let title:String
    let handler: () -> Void
    
}
