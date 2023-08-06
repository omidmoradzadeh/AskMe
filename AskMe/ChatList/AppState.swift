//
//  AppState.swift
//  Ask ME
//
//  Created by Omid on 5.08.2023.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Firebase

class AppState : ObservableObject {
    
    @Published var currentUser : User?
    @Published var navigationPath = NavigationPath()
    var isLogin : Bool {
        return currentUser != nil
    }
    
    init(){
        FirebaseApp.configure()
        
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
