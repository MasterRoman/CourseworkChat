//
//  DetailChatViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 23.05.2021.
//

import Foundation

class DetailChatViewModel{
    
    init() {
        
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .newMessage, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .newMessage, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let chat = notification.object as? Chat {
            
        }
        
    }

    deinit {
        removeNotification()
    }
}
