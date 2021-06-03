//
//  AddChatCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 04.06.2021.
//

import Foundation
import RxSwift

class AddChatCoordinator : BaseCoordinator<Void> {
    private let navigationController : UINavigationController
    private let chatService : ChatService
    private let contactsService : ContactsService
    
    init(navigationController : UINavigationController,chatService : ChatService,contactsService : ContactsService) {
        self.navigationController = navigationController
        self.chatService = chatService
        self.contactsService = contactsService
    }
    
    override func start() -> Observable<Void> {
        let viewController = AddChatViewController()
        let viewModel = AddChatViewModel(chatService: chatService, contactsService: contactsService)
        viewController.viewModel = viewModel
        
        self.navigationController.present(viewController, animated: true, completion: nil)
        
        
        
        return viewModel.output.back
    }
}
