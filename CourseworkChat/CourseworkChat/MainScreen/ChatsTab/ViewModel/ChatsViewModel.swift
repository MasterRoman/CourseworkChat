//
//  ChatsViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 17.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

class ChatsViewModel : ViewModelType {
    
    var input: Input
    var output: Output
    
    
    struct Input {
        let selected : AnyObserver<Chat>
    }
    
    struct Output {
        let selectedhShow : Observable<Chat>
        var chats : Observable<[Chat]>
    }
    
   
    private let networkManager : NetworkClient

    private let selectedCell = PublishSubject<Chat>()
    private var chatsSubject : BehaviorRelay<[Chat]>
    
    init(networkManager : NetworkClient) {
        /////////
        let sender = Sender(senderId: "1", displayName: "1")
        let chat = Chat(senders: [sender], chatBody: ChatBody(chatId: UUID(), messages: [Message(sender: sender, messageId: "1", sentDate:Date(), kind: .text("hello"))]))
        //////
        
        self.chatsSubject = BehaviorRelay<[Chat]>(value: [chat])
        
        self.input = Input(selected: selectedCell.asObserver())
        self.output = Output(selectedhShow: selectedCell.asObservable(), chats: chatsSubject.asObservable())

        self.networkManager = networkManager
        do{
        try self.networkManager.send(message: .newChat(chat: chat))
        }
        catch
        {
            
        }
        registerNotifications()
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
//            let newChat = Observable.of([chat])
//            output.chats = Observable<[Chat]>.combineLatest(output.chats, newChat){
//                $1 + $0
//            }
            chatsSubject.accept([chat] + chatsSubject.value)
        }
        
    }
    
    @objc private func handleNewMessageNotification(notification: NSNotification){
        if let message = notification.object as? ChatBody {
        
        
        }
        
    }

    deinit {
        removeNotifications()
    }
}
