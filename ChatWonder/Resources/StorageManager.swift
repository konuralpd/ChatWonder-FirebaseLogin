//
//  StorageManager.swift
//  ChatWonder
//
//  Created by Mac on 30.06.2022.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    //Firebase'a Fotograf Yukleme
    public func uploaadProfilePicture(with data: Data, fileName: String, completion: @escaping(Result<String, Error>) -> Void) {
        
        storage.child("image/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            self.storage.child("image/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url: \(urlString)")
                completion(.success(urlString))
            }
        }
        
    }
    
    public func downloadURL(for path: String, completion: @escaping  (Result<URL, Error>) -> Void) {
        
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(url))
        }
    }
    
}
