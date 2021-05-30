//
//  MainCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift

class MainCoordinator : BaseCoordinator<Void>{
    
    private let navigationController : UINavigationController
    private let sessionService : SessionService
    
    init(with navigationController : UINavigationController,sessionService : SessionService) {
        self.navigationController = navigationController
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<Void> {
        
        let tabBarController = MainTabBarController()
        
        
        let contactsNavigationController = UINavigationController()
        contactsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        let contactsCoordinator = ContactsCoordinator(with: contactsNavigationController, networkManager: sessionService.networkManager)
        
        let chatsNavigationController = UINavigationController()
        chatsNavigationController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        let chatsCoordinator = ChatsCoordinator(with: chatsNavigationController, networkManager: sessionService.networkManager)
        
        let settingsNavigationController = UINavigationController()
        settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"),tag: 2)
        let settingsCoordinator = SettingsCoordinator(with: settingsNavigationController, sessionService: sessionService)
        
        tabBarController.viewControllers = [contactsNavigationController,
                                            chatsNavigationController,
                                            settingsNavigationController]
        
        navigationController.pushViewController(tabBarController, animated: true)
        
        
        coordinate(to: contactsCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        
        coordinate(to: chatsCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        
        coordinate(to: settingsCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
}