//
//  ChatViewModel.swift
//  AskMe
//
//  Created by Omid on 5.08.2023.
//

import Foundation
import OpenAI


class ChatViewModel : ObservableObject{
    
    @Published var chat : AppChat?
    @Published var messages : [AppMessage] = []
    @Published var messageText : String = ""
    @Published var selectModel : ChatModel = .gpt3_5_turbo
    let chatId: String
    
    init(chatId: String) {
        self.chatId = chatId
    }
    
    func fetchDate(){
        self.messages = [
            AppMessage(id: "1", text: "Hello How Are You?", role: .user, createdAt: Date()),
            AppMessage(id: "2", text: "Tahnk's", role: .assistant, createdAt: Date()),
        ]
    }
    
    
    func sendMessage(){
        var newMessage = AppMessage(id: UUID().uuidString, text: messageText , role: .assistant, createdAt: Date())
        messages.append(newMessage)
    }
}

struct AppMessage : Identifiable , Codable , Hashable {
    let id : String?
    let text : String
    let role : Chat.Role
    let createdAt : Date
}
