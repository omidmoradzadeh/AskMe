//
//  ChatView.swift
//  AskMe
//
//  Created by Omid on 5.08.2023.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var viewModel : ChatViewModel
    
    var body: some View {
        VStack{
            chatSelection
            ScrollViewReader {  scrollView in
                List(viewModel.messages) { message in
                    messageView(for : message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange(of: viewModel.messages) { newValue in
                            scrollToBottom(scrollView: scrollView)
                        }
                }
                .background(Color(UIColor.systemGroupedBackground))
                .listStyle(.plain)
            }
            messageInputView
        }
        .navigationTitle(viewModel.chat?.topic ?? "New Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.fetchDate()
        }
    }
    
    func scrollToBottom(scrollView : ScrollViewProxy){
        guard !viewModel.messages.isEmpty ,
              let lastMessage = viewModel.messages.last else {
            return
        }
        
        withAnimation {
            scrollView.scrollTo(lastMessage.id)
        }
        
    }
    
    var chatSelection : some View {
        Group{
            if let model = viewModel.chat?.model?.rawValue {
                Text(model)
            }
            else {
                Picker(selection: $viewModel.selectModel) {
                    ForEach(ChatModel.allCases,id: \.self) { model in
                        Text(model.rawValue)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.segmented)
                .padding()

            }
        }
    }
    
    func messageView(for  message : AppMessage ) -> some View {
        HStack{
            if message.role == .user {
                Spacer()
            }
            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical , 12)
                .foregroundStyle(message.role == .user ? .white : .black)
                .background( message.role == .user ? .blue : .white)
                .clipShape(RoundedRectangle(cornerRadius: 12 , style: .continuous))
            
            
            if message.role == .assistant {
                Spacer()
            }
        }
    }
    
    var messageInputView : some View {
        HStack{
            TextField("Send a message ... ", text: $viewModel.messageText)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onSubmit {
                    sendMessage()
                }
            Button {
                sendMessage()
            } label: {
                Text("Send")
                    .padding()
                    .foregroundStyle(.white)
                    .bold()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

        }
        .padding()
    }
    
    func sendMessage(){
        task {
            do{
                try await viewModel.sendMessage()
            }
            catch let error {
                print(error)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(viewModel: .init(chatId: ""))
    }
}
