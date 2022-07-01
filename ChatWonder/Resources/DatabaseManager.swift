//
//  DatabaseManager.swift
//  ChatWonder
//
//  Created by Mac on 30.06.2022.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()

    
   
}

extension DatabaseManager {
    
    public func userExist(with email: String, completion: @escaping((Bool)-> Void)) {
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            guard let foundEmail = snapshot.value as? String else { return
                completion(false)
            }
            completion(true)
        }
        
        
    }
    public func insertUser(with user: ChatAppUser, completion: @escaping(Bool) -> Void) {
        
        database.child(user.firstName).setValue(["name": user.firstName]) { error, _ in
            guard error == nil else {
                print(error?.localizedDescription)
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    let newElement: [[String: String]] = [
                        ["name": user.firstName,
                         "email": user.email
                        ],
                       
                    ]
                    
                } else {
                    let newCollection: [[String: String]] = [
                        ["name": user.firstName,
                         "email": user.email
                        ]
                    ]
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            
                            return
                            
                        }
                        completion(true)
                    }
                }
            }
            
        }
    }
    
    public func getAllUsers(completion: @escaping(Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(Error.self as! Error))
                return
            }
            completion(.success(value))
        }
    }
    
}

struct ChatAppUser {
    let firstName: String
    let email: String
    //let profilePictureUrl: String
    
    var profilePictureFileName: String {
        return "\(firstName)_profile_picture.png"
    }
    
}
