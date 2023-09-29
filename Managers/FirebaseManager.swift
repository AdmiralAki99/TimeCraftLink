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
import FirebaseStorage

class FirebaseManager {
    
    /*
     MARK: API Response Error
     */
    
    enum FirebaseAuthError : Error{
        case FailedToCreateUser
        case FailedToGetMetadata
        case FailedToLogInUser
        case FailedToUpdateUser
    }
    // One instance of the manager that can be accessed by the app
    static let firebase_manager = FirebaseManager()
    // Storage reference used by Firebase Storage to create directories
    private static let storage = Storage.storage()
    private static let storageRef = storage.reference()
    
    // One user instance that is stored and used for authentication and details purposes.
    private static var user : FirebaseAuth.User? = nil
    
    /*
     MARK: API Calls
     */
    
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
    
    func signInUser(with email : String , password : String,completion: @escaping (Result<FirebaseAuth.User,Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, err in
            guard let auth = self else{
                completion(.failure(FirebaseAuthError.FailedToLogInUser))
                return
            }
            
            guard let user = result?.user else{
                completion(.failure(FirebaseAuthError.FailedToLogInUser))
                return
            }
            completion(.success(user))
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
    
    func storeImage(){
        
        let localFile = URL(string: "https://images.pexels.com/photos/1420440/pexels-photo-1420440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!

        // Create a reference to the file you want to upload
        let imageTask = Storage.storage().reference().child("file.jpeg")
        
        let currentUploadTask = imageTask.putFile(from: localFile,metadata: StorageMetadata()) { (metadata, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            print("Success")
            
            
        }
    }
    
    func updateProileDisplayName(userName : String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userName
    }
    
    func updateProfileImage(photoURL: URL){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = photoURL
    }
    
}
