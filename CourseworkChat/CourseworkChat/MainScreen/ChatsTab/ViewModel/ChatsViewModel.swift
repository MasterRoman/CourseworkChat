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
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let add : AnyObserver<Void>
        let selected : AnyObserver<ChatCellViewModel?>
        let reload : AnyObserver<Void>
        let newChat : AnyObserver<Chat>
    }
    
    struct Output {
        let add : Observable<Void>
        let selectedhShow : Observable<ChatCellViewModel?>
        var chats : Observable<[ChatCellViewModel]>
        let reload : Observable<Void>
    }
    
    
    private let chatService : ChatService
    
    private let addSubject = PublishSubject<Void>()
    private let selectedCell = BehaviorSubject<ChatCellViewModel?>(value: nil)
    private var chatsRelay : BehaviorRelay<[ChatCellViewModel]>
    private let reloadSubject = PublishSubject<Void>()
    private var newChatSubject = PublishSubject<Chat>()
    
    init(chatService : ChatService) {
        self.chatService = chatService
        
        let chats = chatService.getChats()
        var models : [ChatCellViewModel] = []
        
        for chat in chats {
            let model = ChatCellViewModel(from: chat)
            models.append(model)
        }
        
        self.chatsRelay = BehaviorRelay<[ChatCellViewModel]>(value: models)
        
        self.input = Input(add: addSubject.asObserver(), selected: selectedCell.asObserver(), reload: reloadSubject.asObserver(), newChat: newChatSubject.asObserver())
        self.output = Output(add: addSubject.asObservable(), selectedhShow: selectedCell.asObservable(), chats: chatsRelay.asObservable(), reload: reloadSubject.asObservable())
        
        
        
        reloadAfterBack()
        getNewChat()
        getNewMessages()
        
    }
    
    private func reloadAfterBack(){
        self.output.reload.subscribe(onNext: { [unowned self] in
            do{
                let chat = try self.selectedCell.value()
                let chatId = chat!.chatId
                var chats = self.chatsRelay.value
                if let index = chats.firstIndex(where: {$0.chatId == chatId}) {
                    var chatCell = chats[index]
                    let chatById = chatService.getChat(by: chatId)
                    guard let chat = chatById else {
                        return
                    }
                    let chatBody = chat.chatBody
                    chatCell.configure(with: chatBody)
                    chats[index] = chatCell
                }
                
                DispatchQueue.main.async(group: nil, qos: .userInteractive, flags: .barrier, execute: {
                    self.chatsRelay.accept(chats)
                })
            }catch{
                return
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func getNewChat(){
        
        self.chatService.getNewChat = { [unowned self] chat in
            DispatchQueue.global().async(group: nil, qos: .utility, flags: .barrier, execute: {
                let model = ChatCellViewModel(from: chat)
                chatsRelay.accept([model] + chatsRelay.value)
            })
        }
        
        self.newChatSubject.asObservable().subscribe(onNext: { [weak self] chat in
            guard let self = self else {return}
            self.chatService.sendNewChat(chat: chat)
            DispatchQueue.global().async(group: nil, qos: .utility, flags: .barrier, execute: {
                let model = ChatCellViewModel(from: chat)
                self.chatService.addChat(by: chat.chatBody.chatId , chat: chat)
                self.chatsRelay.accept([model] + self.chatsRelay.value)
            })
            
        })
        .disposed(by: disposeBag)
    }
    
    private func getNewMessages(){
        
        self.chatService.getNewMessages = { [unowned self] messages in
            var chats = self.chatsRelay.value
            if let index = chats.firstIndex(where: {$0.chatId == messages.chatId}) {
                var chat = chats[index]
                chat.configure(with: messages)
                chats[index] = chat
            }
            
            DispatchQueue.main.async(group: nil, qos: .userInteractive, flags: .barrier, execute: {
                self.chatsRelay.accept(chats)
            })
        }
    }
    
    deinit {
        self.chatService.getNewChat = nil
        self.chatService.getNewMessages = nil
    }
    
}
