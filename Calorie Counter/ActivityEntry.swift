//
//  ActivityEntry.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-07-29.
//

import Foundation

struct ActivityEntry : Identifiable{
    let id = UUID()
    let name: String
    let value : Double
}

struct NutrionalInformation : Identifiable{
    let id = UUID()
    let name : String
    let value: Double
}
