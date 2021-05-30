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
        let selected : AnyObserver<ChatCellViewModel>
    }
    
    struct Output {
        let selectedhShow : Observable<ChatCellViewModel>
        var chats : Observable<[ChatCellViewModel]>
    }
    
    
    private let chatService : ChatService
    
    private let selectedCell = PublishSubject<ChatCellViewModel>()
    private var chatsRelay : BehaviorRelay<[ChatCellViewModel]>
    
    init(chatService : ChatService) {
        self.chatService = chatService
        
        let chats = chatService.getChats()
        var models : [ChatCellViewModel] = []
        for chat in chats {
            let model = ChatCellViewModel(from: chat)
            models.append(model)
        }
        
        self.chatsRelay = BehaviorRelay<[ChatCellViewModel]>(value: models)
        
        self.input = Input(selected: selectedCell.asObserver())
        self.output = Output(selectedhShow: selectedCell.asObservable(), chats: chatsRelay.asObservable())
        
        
        
        registerNotifications()
    }
    
    private func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatNotification), name: .newChat, object: nil)
        
    }
    
    private func removeNotifications(){
        NotificationCenter.default.removeObserver(self, name: .newChat, object: nil)
    }
    
    @objc private func handleNewChatNotification(notification: NSNotification){
        if let chat = notification.object as? Chat {
            //            let newChat = Observable.of([chat])
            //            output.chats = Observable<[Chat]>.combineLatest(output.chats, newChat){
            //                $1 + $0
            //            }
            //          chatsRelay.accept([chat] + chatsSubject.value)
        }
        
    }
    
    deinit {
        removeNotifications()
    }
}
