//
//  ChatService.swift
//  CourseworkChat
//
//  Created by Admin on 30.05.2021.
//

import Foundation

class ChatService{
    private let networkManager : NetworkClient
    private var chatSource = Dictionary<UUID,Chat>()
    
    var getNewChat : ((_ chat : Chat) -> (Void))?
    var getNewMessages : ((_ messages : ChatBody) -> (Void))?
    
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
        DispatchQueue.global(qos: .utility).async { [self] in
            if let chat = notification.object as? Chat {
                DispatchQueue.global().async(flags: .barrier, execute: {
                    let id = chat.chatBody.chatId
                    chatSource[id] = chat
                })
                self.getNewChat?(chat)
            }
        }
        
        
    }
    
    @objc private func handleNewMessageNotification(notification: NSNotification){
        DispatchQueue.global(qos: .utility).async { [self] in
            if let chatBody = notification.object as? ChatBody {
                let id = chatBody.chatId
                DispatchQueue.global().async(flags: .barrier, execute: {
                    chatSource[id]?.chatBody.messages.append(contentsOf: chatBody.messages)
                })
                self.getNewMessages?(chatBody)
            }
        }
    }
    
    deinit {
        removeNotifications()
    }
}
