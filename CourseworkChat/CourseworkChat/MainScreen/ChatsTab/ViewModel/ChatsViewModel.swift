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
        let selected : AnyObserver<ChatCellViewModel?>
        let reload : AnyObserver<Void>
    }
    
    struct Output {
        let selectedhShow : Observable<ChatCellViewModel?>
        var chats : Observable<[ChatCellViewModel]>
        let reload : Observable<Void>
    }
    
    
    private let chatService : ChatService
    
    private let selectedCell = BehaviorSubject<ChatCellViewModel?>(value: nil)
    private var chatsRelay : BehaviorRelay<[ChatCellViewModel]>
    private let reloadSubject = PublishSubject<Void>()
    
    init(chatService : ChatService) {
        self.chatService = chatService
        
        let chats = chatService.getChats()
        var models : [ChatCellViewModel] = []
        
        for chat in chats {
            let model = ChatCellViewModel(from: chat)
            models.append(model)
        }
        
        self.chatsRelay = BehaviorRelay<[ChatCellViewModel]>(value: models)
        
        self.input = Input(selected: selectedCell.asObserver(), reload: reloadSubject.asObserver())
        self.output = Output(selectedhShow: selectedCell.asObservable(), chats: chatsRelay.asObservable(), reload: reloadSubject.asObservable())
        
        
        
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
