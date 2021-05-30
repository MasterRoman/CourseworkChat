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
    
    struct Input {
        let back : AnyObserver<Void>
        
    }
    
    struct Output{
        let  back : Observable<Void>
        
    }
    
    private let backSubject = PublishSubject<Void>()
    
    init() {
        
        self.input = Input(back: backSubject.asObserver())
        self.output = Output(back: backSubject.asObservable())
        
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .newMessage, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .newMessage, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let chat = notification.object as? ChatBody {
            
        }
        
    }
    
    deinit {
        removeNotification()
    }
}
