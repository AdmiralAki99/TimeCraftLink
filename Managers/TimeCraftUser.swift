//
//  TimeCraftUser.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-19.
//

import Foundation
import FirebaseAuth

class TimeCraftUser{
    let email: String
    let uuid : String
    
    init(email:String,uuid:String) {
        self.email = email
        self.uuid = uuid
    }
    
    init(user:FirebaseAuth.User){
        self.email = user.email ?? ""
        self.uuid = user.uid
    }
    
}
