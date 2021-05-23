//
//  ChatsViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 17.05.2021.
//

import Foundation
import RxSwift

class ChatsViewModel {
    
    let selected : AnyObserver<IndexPath>
    let selectedhShow : Observable<IndexPath>
    private let networkManager : NetworkClient
    
    private let selectedCell = PublishSubject<IndexPath>()
    
    init(networkManager : NetworkClient) {
        selected = selectedCell.asObserver()
        selectedhShow = selectedCell.asObservable()
        
        self.networkManager = networkManager
        
        registerNotification()
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .newChat, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .newChat, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let chat = notification.object as? Chat {
            
        }
        
    }

    deinit {
        removeNotification()
    }
}
