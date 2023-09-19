//
//  FirebaseManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-18.
//

import Foundation
import FirebaseCore
import FirebaseAuth

class FirebaseManager {
    static let firebase_manager = FirebaseManager()
    
    private static var user : FirebaseAuth.User? = nil
    
    func createFirebaseUser(with email : String,passoword: String,completion: @escaping(_ success: Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: passoword) { result, err in
            guard let user = result?.user , err == nil else{
                completion(false)
//                print(err?.localizedDescription)
                print(err.debugDescription)
                return
            }
            
            completion(true)
            
        }
        
    }
    
    func signInUser(with email : String , password : String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, err in
            guard let user = self else{
                return
            }
            FirebaseManager.user = result?.user
        }
    }
    
    func getUserDetails() -> FirebaseAuth.User?{
        return FirebaseManager.user
        
        
    }
    
    func getDetails(){
        
    }
    
    func signOutUser(){
        do{
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
