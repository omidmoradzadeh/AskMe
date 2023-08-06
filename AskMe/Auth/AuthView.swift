//
//  AuthView.swift
//  Ask ME
//
//  Created by Omid on 5.08.2023.
//

import SwiftUI

struct AuthView: View {
    
    @ObservedObject var viewModel  : AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState  : AppState
    
    var body: some View {
        VStack{
            Text("Chat GPT APP")
                .font(.title)
                .bold()
            
            TextField("Email", text: $viewModel.emailText)
                .padding()
                .background(.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if viewModel.isPasswordVisible {
                SecureField("Password", text: $viewModel.PasswordText)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .textInputAutocapitalization(.never)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            if viewModel.isLoading{
                ProgressView()
            }
            else{
                
                Button {
                    viewModel.autenticate(appState: appState)
                } label: {
                    Text(viewModel.userExist ? "Login" : "Create User")
                }
                .padding()
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12 , style: .continuous))
            }
            
         
          

        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
