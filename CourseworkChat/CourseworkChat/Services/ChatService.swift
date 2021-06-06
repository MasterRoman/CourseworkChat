//
//  ChatService.swift
//  CourseworkChat
//
//  Created by Admin on 30.05.2021.
//

import Foundation

class ChatService{
    
    var sender : Sender
    private let networkManager : NetworkClient
    private let userManager : UserManager
    private let storageService : StorageService
    private var chatSource : Dictionary<UUID,Chat>
    
    var getNewChat : ((_ chat : Chat) -> (Void))?
    var getNewMessages : ((_ messages : ChatBody) -> (Void))?
    
    private let queue = DispatchQueue.init(label: "chat.service", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    init(networkManager : NetworkClient, userManager : UserManager,storageService : StorageService) {
        self.networkManager = networkManager
        self.userManager = userManager
        self.storageService = storageService
        
        let login = userManager.getLogin()
        
        let chats = storageService.getChats()
        if let chats = chats{
            self.chatSource = chats
        }
        else
        {
            self.chatSource = Dictionary<UUID,Chat>()
        }
        
        self.sender = Sender(senderId: login, displayName: login)
        registerNotifications()
    }
    
    func getChats()->[Chat]{
        return Array(chatSource.values)
    }
    
    func getChat(by id:UUID) -> Chat?{
        queue.sync {
            return chatSource[id]
        }
    }
    
    func addChat(by id:UUID,chat : Chat){
        queue.async(flags: .barrier, execute: {
            self.chatSource[id] = chat
        })
    }
    
    func sendMessage(message : ChatBody){
        do {
            try networkManager.send(message: .newMessage(message: message))
        } catch (let error) {
            print(error)
        }
    }
    
    func sendNewChat(chat : Chat){
        DispatchQueue.global(qos: .utility).async {
            do {
                try self.networkManager.send(message: .newChat(chat: chat))
            } catch (let error) {
                print(error)
            }
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
            self.chatSource[id] = chat
            
            self.getNewChat?(chat)
            
            DispatchQueue.global(qos: .background).async {
                self.storageService.addChat(chat: chat)
            }
        }
        
        
    }
    
    @objc private func handleNewMessageNotification(notification: NSNotification){
        
        if let chatBody = notification.object as? ChatBody {
            let id = chatBody.chatId
            queue.async(flags: .barrier, execute: {
                self.chatSource[id]?.chatBody.messages.append(contentsOf: chatBody.messages)
            })
            self.getNewMessages?(chatBody)
            
        }
        
    }
    
    deinit {
        removeNotifications()
    }
}
