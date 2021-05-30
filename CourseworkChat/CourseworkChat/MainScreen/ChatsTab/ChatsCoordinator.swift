//
//  ChatsCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift


class ChatsCoordinator : BaseCoordinator<Void> {
    
    private let navigationController : UINavigationController
    private let chatService : ChatService
    
    init(with navigationController : UINavigationController,chatService : ChatService) {
        self.navigationController = navigationController
        self.chatService = chatService
    }
    
    override func start() -> Observable<Void> {
        let viewController = ChatsViewController()
        let viewModel = ChatsViewModel(chatService: chatService)
        viewController.viewModel = viewModel
        
        viewModel.output.selectedhShow
            .subscribe(onNext: { [weak self] model in
                guard let self = self else {return}
                let chat = self.chatService.getChat(by: model.chatId)
                guard let item = chat else {return}
                self.showDetailChatCoordinator(with: item, navigationController: self.navigationController)
            }).disposed(by: disposeBag)
        
        
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
    
    private func showDetailChatCoordinator(with chat: Chat,navigationController : UINavigationController) {
        let detailChatCoordinator = DetailChatCoordinator(with: chat, navigationController: navigationController, chatService : chatService)
        coordinate(to: detailChatCoordinator)
            .subscribe(onNext: {self.navigationController.popViewController(animated: true)})
            .disposed(by: disposeBag)
    }
    
}
