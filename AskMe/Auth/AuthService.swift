//
//  AuthService.swift
//  Ask ME
//
//  Created by Omid on 5.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AuthService {
    
    let db = Firestore.firestore()
    
    func checkUserExists(email : String) async throws -> Bool{
        let docSnapshot = db.collection("users").whereField("email" , isEqualTo : email).count
        let count = try await docSnapshot.getAggregation(source: .server).count
        return Int(truncating: count) > 0
    }
    
    func login(email : String , password : String , userExits : Bool) async throws -> AuthDataResult?{
        
        guard !password.isEmpty else { return nil}
        
        if userExits {
            return try await Auth.auth().signIn(withEmail: email, password: password)
        }
        else{
            return try await Auth.auth().createUser(withEmail: email, password: password)
        }
        
    }
}
