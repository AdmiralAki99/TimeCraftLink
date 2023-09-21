//
//  TimeCraftUser.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-19.
//

import Foundation
import FirebaseAuth

class TimeCraftUser{
    
    static var user = TimeCraftUser()
    
    let userName : String
    let email: String
    let uuid : String
    var userRef : FirebaseAuth.User? = nil
    
    init(){
        userName = ""
        email = ""
        uuid = ""
    }
    
    // Creates a User object where Firebase Reference is Non existant
    init(email:String,uuid:String,userName:String) {
        self.email = email
        self.uuid = uuid
        self.userName = userName
    }
    
    init(user:FirebaseAuth.User,userName:String){
        self.email = user.email ?? ""
        self.uuid = user.uid
        self.userRef = user
        self.userName = userName
    }
    
}
