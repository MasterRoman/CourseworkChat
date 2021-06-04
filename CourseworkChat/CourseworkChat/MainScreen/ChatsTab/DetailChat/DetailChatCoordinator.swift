//
//  DetailChatCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift

class DetailChatCoordinator : BaseCoordinator<Void> {
    private let navigationController : UINavigationController
    private let chatService : ChatService
    private let chat : Chat
    private let title : String
    
    init(with chat : Chat,title : String,navigationController : UINavigationController,chatService : ChatService) {
        self.navigationController = navigationController
        self.chatService = chatService
        self.chat = chat
        self.title = title
    }
    
    override func start() -> Observable<Void> {
        let viewController = DetailChatViewController()
        let viewModel = DetailChatViewModel(with: chat,title : title,chatService: chatService)
        viewController.viewModel = viewModel
        self.navigationController.pushViewController(viewController, animated: true)
        return viewModel.output.back
    }
}
