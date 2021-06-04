//
//  DetailChatViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 23.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

class DetailChatViewModel : ViewModelType{
    
    var input: Input
    var output: Output
    
    private let disposeBag = DisposeBag()
    
    private let chatService : ChatService
    
    struct Input {
        let back : AnyObserver<Void>
        
        let messageText : AnyObserver<String>
        let send : AnyObserver<Void>
    }
    
    struct Output{
        let back : Observable<Void>
        let chat : Chat
        let reload : Observable<Void>
        let curSender : Sender
    }
    
    private let backSubject = PublishSubject<Void>()
    private let reloadSubject = PublishSubject<Void>()
    private let textSubject =  BehaviorSubject<String>(value: "")
    private let sendSubject = PublishSubject<Void>()
    
    init(with chat : Chat,chatService : ChatService) {
        self.chatService = chatService
        
        self.input = Input(back: backSubject.asObserver(), messageText: textSubject.asObserver(), send: sendSubject.asObserver())
    
        let sender = chatService.sender
        
        self.output = Output(back: backSubject.asObservable(), chat: chat, reload: reloadSubject.asObservable(), curSender: sender)
        
        
        self.sendSubject.asObservable().subscribe(onNext: { [unowned self] in
            do{
                let text = try textSubject.value()
                if (text.count > 0){
                    makeNewMessage(text: text)
                }
            }catch{
                return
            }
            
        }).disposed(by: disposeBag)
        
        registerNotification()
    }
    
    private func makeNewMessage(text : String){
        let chat = self.output.chat
        let date = Date()
        let textHash = text.hashValue
        let messageId = String(textHash) + String(date.hashValue)
      
        let message = Message(sender: chatService.sender, messageId: messageId, sentDate: date, kind: .text(text))
        
        chat.chatBody.messages.append(message)
        reloadSubject.onNext(())
        
        DispatchQueue.global(qos: .utility).async {
            let chatId = chat.chatBody.chatId
            let chatBody = ChatBody(chatId: chatId, messages: [message])
            self.chatService.sendMessage(message: chatBody)
        }
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
                if chat.chatId == self.output.chat.chatBody.chatId{
                    self.reloadSubject.onNext(())
                }
            }
        }
    }
    
    deinit {
        removeNotification()
    }
}
