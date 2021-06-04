//
//  AddChatCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 04.06.2021.
//

import Foundation
import RxSwift

enum AddChatCoordinatorResult{
    case chat(Chat)
    case cancel
}

class AddChatCoordinator : BaseCoordinator<AddChatCoordinatorResult> {
    private let navigationController : UINavigationController
    private let contactsService : ContactsService
    private let sessionService : SessionService
    
    init(navigationController : UINavigationController,contactsService : ContactsService,sessionService : SessionService) {
        self.navigationController = navigationController
        self.contactsService = contactsService
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<AddChatCoordinatorResult> {
        let viewController = AddChatViewController()
        let viewModel = AddChatViewModel(contactsService: contactsService,sessionService : sessionService)
        viewController.viewModel = viewModel
        
        self.navigationController.pushViewController(viewController, animated: true)
        
        let cancel = viewModel.output.back.map{_ in AddChatCoordinatorResult.cancel}
        let chat = viewModel.output.chat.map({AddChatCoordinatorResult.chat($0)})
        
        
        return Observable.merge(cancel,chat)
            .take(1)
            .do(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
    }
}


