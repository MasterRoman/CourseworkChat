//
//  DetailChatViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 23.05.2021.
//

import Foundation
import RxSwift

class DetailChatViewModel : ViewModelType{
    
    var input: Input
    var output: Output
    
    private let chatService : ChatService
    
    struct Input {
        let back : AnyObserver<Void>
        
    }
    
    struct Output{
        let back : Observable<Void>
        let chat : Chat
        let reload : Observable<Void>
    }
    
    private let backSubject = PublishSubject<Void>()
    private let reloadSubject = PublishSubject<Void>()
    
    init(with chat : Chat,chatService : ChatService) {
        self.chatService = chatService
        
        self.input = Input(back: backSubject.asObserver())
        self.output = Output(back: backSubject.asObservable(), chat: chat, reload: reloadSubject.asObservable())
        
    
        
        registerNotification()
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .newMessage, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .newMessage, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        DispatchQueue.main.async {
            if let chat = notification.object as? ChatBody {
                self.output.chat.chatBody.messages.append(contentsOf: chat.messages)
                self.reloadSubject.onNext(())
            }
        }
    }
    
    deinit {
        removeNotification()
    }
}
