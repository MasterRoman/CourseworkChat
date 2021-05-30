//
//  ChatService.swift
//  CourseworkChat
//
//  Created by Admin on 30.05.2021.
//

import Foundation

class ChatService{
    private let networkManager : NetworkClient
    var chatSource = Dictionary<UUID,Chat>()
    
    init(networkManager : NetworkClient) {
        self.networkManager = networkManager
        registerNotifications()
    }
    
    func getChats()->[Chat]{
        return Array(chatSource.values)
    }
    
    func getChat(by id:UUID) -> Chat?{
        return chatSource[id]
    }
    
    func sendMessage(message : ChatBody){
        do {
            try networkManager.send(message: .newMessage(message: message))
        } catch (let error) {
            print(error)
        }
    }
    
    func sendNewChat(chat : Chat){
        do {
            try networkManager.send(message: .newChat(chat: chat))
        } catch (let error) {
            print(error)
        }
    }
    
    private func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatNotification), name: .newChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewMessageNotification), name: .newMessage, object: nil)
    }
    
    private func removeNotifications(){
        NotificationCenter.default.removeObserver(self, name: .newChat, object: nil)
        NotificationCenter.default.removeObserver(self, name: .newMessage, object: nil)
    }
    
    @objc private func handleNewChatNotification(notification: NSNotification){
        if let chat = notification.object as? Chat {
            let id = chat.chatBody.chatId
            chatSource[id] = chat
        }
        
    }
    
    @objc private func handleNewMessageNotification(notification: NSNotification){
        DispatchQueue.main.async { [self] in
            if let chatBody = notification.object as? ChatBody {
                let id = chatBody.chatId
                chatSource[id]?.chatBody.messages.append(contentsOf: chatBody.messages)
                
            }
        }
    }
    
    deinit {
        removeNotifications()
    }
}
