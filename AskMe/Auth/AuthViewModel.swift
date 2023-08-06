//
//  AuthViewModel.swift
//  Ask ME
//
//  Created by Omid on 5.08.2023.
//

import Foundation


class AuthViewModel : ObservableObject {
    
    @Published var emailText : String = ""
    @Published var PasswordText : String = ""
    
    @Published var isLoading = false
    @Published var isPasswordVisible = false
    @Published var userExist = false

    let authService = AuthService()
    
    func autenticate(appState : AppState){
        isLoading = true
        
        Task{
            do{
                if isPasswordVisible {
                    let result = try await authService.login(email: emailText, password: PasswordText, userExits: userExist)
                    await MainActor.run(body: {
                        guard let result = result else { return }
                        // update state
                        appState.currentUser = result.user
                    })
                }
                else{
                    userExist = try await authService.checkUserExists(email: emailText)
                    isPasswordVisible = true
                    
                }
                isLoading = false
            }
            catch {
                print(error)
                await MainActor.run(body: {
                    isLoading = false
                })
                
            }
        }
    }
}
