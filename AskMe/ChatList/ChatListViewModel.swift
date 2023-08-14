//
//  ChatListViewModel.swift
//  Ask ME
//
//  Created by Omid on 5.08.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import OpenAI

class ChatListViewModel : ObservableObject {
    
    @Published var chats : [AppChat] = []
    @Published var loadingState : ChatListState = .none
    @Published var isShowingProfileView : Bool = false
    
    private let db = Firestore.firestore()
    
    func fetchData(user : String){
//        self.chats = [
//            AppChat(id: "1", topic: "Some Topic", model: .gpt3_5_turbo, lastMessageSent: Date(), owner: "123"),
//            AppChat(id: "2", topic: "Some Other Topic", model: .gpt4, lastMessageSent: Date(), owner: "123"),
//        ]
        self.loadingState = .resultFound
        
        if loadingState == .none{
            loadingState = .loading
            db.collection("chats").whereField("owner", isEqualTo: user ).addSnapshotListener{ [weak self] querySnapshot , error in
                guard let self = self ,
                      let document  = querySnapshot?.documents ,
                      !document.isEmpty
                else {
                    self?.loadingState = .noResult
                    return
                }
             
                self.chats = document.compactMap({ snapshot -> AppChat? in
                    return try? snapshot.data(as: AppChat.self)
                })
                .sorted(by: {$0.lastMessageSent > $1.lastMessageSent})
                
                self.loadingState = .resultFound
            }
        }
    }
    
    func createChat(user : String?) async throws -> String{
        let document = try await db.collection("chats").addDocument(data: ["lastMessageSent" : Date() , "owner" : user ?? ""])
        return document.documentID
    }
    
    func showProfile(){
        isShowingProfileView = true
    }
    
    func createChat(){
        
    }
    func deleteChat(chat : AppChat){
        guard let id = chat.id else {return}
        db.collection("chats").document().delete()
    }
    
 
}

enum ChatListState {
    case loading
    case noResult
    case resultFound
    case none
}

struct AppChat : Codable , Identifiable {
    @DocumentID var id : String?
    let topic : String?
    var model : ChatModel?
    let lastMessageSent : FireStoreDate
    let owner : String
    
    var lastMessageTimeAgo : String {
        let now : Date =  Foundation.Date()
        let components = Calendar.current.dateComponents([.second , .minute , .hour , .day ,.month , .year], from: lastMessageSent.date, to:  now)
        
        let timeUnits : [(value : Int? , unit : String)] = [
            (components.year , "year") ,
            (components.month , "month") ,
            (components.day , "day") ,
            (components.hour , "hour") ,
            (components.minute , "minute") ,
            (components.second , "second") ,
        ]
        
        for timeUnit in timeUnits {
            if let value = timeUnit.value , value > 0 {
                return "\(value) \(timeUnit.unit)\(value == 1 ? "" : "s") ago"
            }
        }
        return "just now"
    }
}

enum ChatModel: String , Codable , CaseIterable , Hashable {
    case gpt3_5_turbo = "GPT 3.5 Turbo"
    case gpt4 = "Gpt 4"
    
    var tintColor : Color {
        switch self {
        case .gpt3_5_turbo :
            return .green
        
        case .gpt4 :
            return .purple
        }
    }
    
    var model : Model {
        switch self {
        case .gpt3_5_turbo :
            return .gpt3_5Turbo
        case .gpt4 :
            return .gpt4
        }
    }
}


struct FireStoreDate : Codable , Hashable , Comparable {
    
    static func < (lhs: FireStoreDate, rhs: FireStoreDate) -> Bool {
        lhs.date < rhs.date
    }
    
    var date : Date
    
    init(_ date : Date =  Date()){
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Timestamp.self)
        date = timestamp.dateValue()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let timestamp = Timestamp(date: date)
        try container.encode(timestamp)
    }
    
    
}
