//
//  ProfileView.swift
//  AskMe
//
//  Created by Omid on 5.08.2023.
//

import SwiftUI

struct ProfileView: View {
    
    @State var apiKey : String = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    
    var body: some View {
        List{
            Section("Open Ai API Key") {
                TextField("Enter Key", text: $apiKey){
                    UserDefaults.standard.setValue(apiKey, forKey: "openai_api_key")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
