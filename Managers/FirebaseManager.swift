//
//  FirebaseManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-18.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    
    enum FirebaseAuthError : Error{
        case FailedToCreateUser
    }
    
    static let firebase_manager = FirebaseManager()
    private static let storage = Storage.storage()
    private static let storageRef = storage.reference()
    
    private static var user : FirebaseAuth.User? = nil
    
    func createFirebaseUser(with email : String,passoword: String,completion: @escaping(Result<FirebaseAuth.User,Error>) -> Void){
        Auth.auth().createUser(withEmail: email, password: passoword) { result, err in
            guard let user = result?.user , err == nil else{
                completion(.failure(FirebaseAuthError.FailedToCreateUser))
                print(err?.localizedDescription)
                return
            }
            
            completion(.success(user))
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
    
    func signOutUser(){
        do{
            try Auth.auth().signOut()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func createStorage(user : FirebaseAuth.User){
        
    }
    
}
