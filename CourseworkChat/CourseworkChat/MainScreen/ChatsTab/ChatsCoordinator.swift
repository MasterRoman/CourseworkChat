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
    private let sessionService : SessionService
    private let contactsService : ContactsService
    
    init(with navigationController : UINavigationController,chatService : ChatService,sessionService : SessionService,contactsService : ContactsService) {
        self.navigationController = navigationController
        self.chatService = chatService
        self.sessionService = sessionService
        self.contactsService = contactsService
    }
    
    override func start() -> Observable<Void> {
        let viewController = ChatsViewController()
        let viewModel = ChatsViewModel(chatService: chatService)
        viewController.viewModel = viewModel
        
        viewModel.output.selectedhShow
            .subscribe(onNext: { [weak self] cellModel in
                guard let self = self else {return}
                guard let model = cellModel else {return}
                let chat = self.chatService.getChat(by: model.chatId)
                guard let item = chat else {return}
                self.showDetailChatCoordinator(with: item,title : model.dialogTitle ,navigationController: self.navigationController)
                    .subscribe(onNext:{ [weak self, weak viewModel] in
                        guard let self = self else {return}
                        self.navigationController.popViewController(animated: true)
                        viewModel?.input.reload.onNext(())
                    })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        
        viewModel.output.add
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.showAddChatCoordinator()
                    .filter({$0 != nil})
                    .map({$0!})
                    .subscribe(onNext: { [weak viewModel] chat in
                        viewModel?.input.newChat.onNext(chat)
                        
                    })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        
        self.navigationController.pushViewController(viewController, animated: true)
        return sessionService.status.filter{!$0!}.map { [weak self] _ in self?.navigationController.viewControllers.removeAll(); Void()}.take(1)
    }
    
    private func showDetailChatCoordinator(with chat: Chat,title : String,navigationController : UINavigationController) -> Observable<Void> {
        let detailChatCoordinator = DetailChatCoordinator(with: chat,title : title,navigationController: navigationController, chatService : chatService)
        return coordinate(to: detailChatCoordinator)
    }
    
    private func showAddChatCoordinator() -> Observable<Chat?> {
        let addChatCoordinator = AddChatCoordinator(navigationController: navigationController, contactsService: contactsService,sessionService : sessionService)
        return coordinate(to: addChatCoordinator)
            .map({ result  in
                switch result{
                case .chat(let chat):
                    return chat
                case .cancel:
                    return nil
                }
                
            })
    }
    
}
