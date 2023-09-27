//
//  TimeCraftUser.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-19.
//

import Foundation
import FirebaseAuth

class TimeCraftUser{
    // App will only have one instance of user that is to be used
    static var user = TimeCraftUser()
    
    // User has a username, email, uuid (optional since there is only one user in the App) and Firebase Ref
    let userName : String
    let email: String
    let uuid : String
    var userRef : FirebaseAuth.User? = nil
    
    init(){
        userName = ""
        email = ""
        uuid = ""
    }
    
    /*
     MARK: Functions
     */
    
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
