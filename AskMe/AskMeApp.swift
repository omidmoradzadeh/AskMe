//
//  AskMeApp.swift
//  AskMe
//
//  Created by Omid on 5.08.2023.
//

import SwiftUI

@main
struct AskMeApp: App {
    @ObservedObject var appState : AppState = AppState()
    var body: some Scene {
        WindowGroup {
            if appState.isLogin {
                NavigationStack(path: $appState.navigationPath) {
                    ChatListView()
                        .environmentObject(appState)
                }
            }
            else{
                AuthView()
                    .environmentObject(appState)
            }
        }
    }
}
