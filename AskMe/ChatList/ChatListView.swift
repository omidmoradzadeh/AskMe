//
//  ChatListView.swift
//  Ask ME
//
//  Created by Omid on 5.08.2023.
//

import SwiftUI

struct ChatListView: View {
    
    @StateObject var viewModel : ChatListViewModel = ChatListViewModel()
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        
        Group{
            switch viewModel.loadingState {
            case   .loading , .none :
                Text("Loading chats ... ")
                
            case .noResult  :
                Text("No Chat's")
            case .resultFound :
                
                
                List{
                    ForEach(viewModel.chats) { chat in
                        NavigationLink(value: chat.id) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(chat.topic ?? "New Chat")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(chat.model?.rawValue ?? "")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundColor( chat.model?.tintColor ?? .white)
                                        .padding(6)
                                        .background((chat.model?.tintColor ?? .white).opacity(0.1))
                                        .clipShape(Capsule(style: RoundedCornerStyle.continuous))
                                }
                                Text(chat.lastMessageTimeAgo)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .swipeActions {
                            Button(role : .destructive){
                                viewModel.deleteChat(chat: chat)
                            } label : {
                                Label("Delete", image: "trash.fill")
                            }
                            
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Chats")
        .toolbar(content: {
            ToolbarItem(placement : .navigationBarTrailing) {
                Button {
                    viewModel.showProfile()
                } label: {
                    Image(systemName: "person")
                }
            }

            ToolbarItem(placement : .navigationBarTrailing) {
                Button {
                    Task{
                        
                        do{
                            let chatId = try await viewModel.createChat(user: appState.currentUser?.uid)
                            appState.navigationPath.append(chatId)
                        }
                        catch let error{
                            print(error)
                        }
                        
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        })
        .sheet(isPresented:  $viewModel.isShowingProfileView){
            ProfileView()
        }
        .navigationDestination(for: String.self, destination: { chatId in
            ChatView(viewModel: .init(chatId : chatId))
        })
        .onAppear{
            if viewModel.loadingState == .none {
                viewModel.fetchData(user:  appState.currentUser?.uid ?? "")
            }
        }
    }
}


struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
