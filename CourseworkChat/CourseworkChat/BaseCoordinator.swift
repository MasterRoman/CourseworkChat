//
//  BaseCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 16.05.2021.
//

import Foundation
import RxSwift

class BaseCoordinator<ResultType>{
    let disposeBag = DisposeBag()
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: {
                [weak self] _ in self?.free(coordinator: coordinator)
            })
    }
    
    
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

class SceneCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        navigationController.isNavigationBarHidden = true
        
        do {
            let networkManager = try NetworkManager()
            let userManager = UserManager()
            let sessionService = SessionService(userManager: userManager, networkManager: networkManager)
            sessionService.status
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] status in
                    guard let self = self else {return}
                    if status != nil{
                        status! ?
                            self.showMainCoordinator(with: navigationController, sessionService: sessionService):
                            self.showAuthCoordinator(with: navigationController, sessionService : sessionService)
                    }
                }).disposed(by: disposeBag)
            
            
        } catch (_) {
            
        }
        
        
        
        return Observable.never()
    }
    
    private func showAuthCoordinator(with navigationController : UINavigationController,sessionService : SessionService){
        let authCoordinator = AuthCoordinator(with: navigationController,sessionService: sessionService)
        coordinate(to: authCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showMainCoordinator(with navigationController : UINavigationController,sessionService : SessionService){
        let mainCoordinator = MainCoordinator(with: navigationController, sessionService: sessionService)
        coordinate(to: mainCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

class AuthCoordinator : BaseCoordinator<Void>{
    
    private let navigationController : UINavigationController
    private let sessionService : SessionService
    
    init(with navigationController : UINavigationController,sessionService : SessionService) {
        self.navigationController = navigationController
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<Void> {
        let viewController = AuthorizationViewController()
        let viewModel = AuthorizationViewModel(with:sessionService)
        viewController.viewModel = viewModel
        
        viewModel.output.registerShow
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.showRegistrationCoordinator(with: self.navigationController)
            }).disposed(by: disposeBag)
        
        //        viewModel.output.success
        //            .observeOn(MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] _ in
        //                guard let self = self else {return}
        //                self.navigationController.popViewController(animated: true)
        //            }).disposed(by: disposeBag)
        
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
    
    private func showRegistrationCoordinator(with navigationController : UINavigationController){
        let registrationCoordinator = RegistrationCoordinator(with: navigationController, sessionService : sessionService)
        coordinate(to: registrationCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

class RegistrationCoordinator : BaseCoordinator<Void>{
    
    private let navigationController : UINavigationController
    private let sessionService : SessionService
    
    init(with navigationController : UINavigationController,sessionService : SessionService) {
        self.navigationController = navigationController
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<Void> {
        let viewController = RegistrationViewController(with: .login)
        let viewModel = RegistrationLoginViewModel(with: sessionService.networkManager)
        viewController.viewModel = viewModel 
        
        viewModel.output.isSuccess
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                if (success){
                    guard let self = self else {return}
                    let passwordViewController = RegistrationViewController(with: .password)
                    let viewModel = RegistrationPasswordViewModel(with: viewModel.login ,sessionService: self.sessionService)
                    passwordViewController.viewModel = viewModel
                    viewModel.output.isSuccess
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self] success in
                            if (success){
                                guard let self = self else {return}
                                self.navigationController.isNavigationBarHidden = true
                                self.navigationController.popToRootViewController(animated: true)
                            }
                        }).disposed(by: self.disposeBag)
                    self.navigationController.pushViewController(passwordViewController, animated: true)
                }
            }).disposed(by: disposeBag)
        
        navigationController.isNavigationBarHidden = false
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
    
    //    private func showRegistrationCoordinator(with navigationController : UINavigationController){
    //        let detailChatCoordinator = DetailChatCoordinator(with: navigationController)
    //        coordinate(to: detailChatCoordinator)
    //            .subscribe()
    //            .disposed(by: disposeBag)
    //    }
}



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

class ChatsCoordinator : BaseCoordinator<Void> {
    
    private let navigationController : UINavigationController
    private let networkManager : NetworkClient
    
    init(with navigationController : UINavigationController,networkManager : NetworkClient) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = ChatsViewController()
        let viewModel = ChatsViewModel(networkManager: networkManager)
        viewController.viewModel = viewModel
        
        viewModel.selectedhShow
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.showDetailChatCoordinator(with: self.navigationController)
            }).disposed(by: disposeBag)
        
        
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
    
    private func showDetailChatCoordinator(with navigationController : UINavigationController){
        let detailChatCoordinator = DetailChatCoordinator(with: navigationController, networkManager: networkManager)
        coordinate(to: detailChatCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}

class DetailChatCoordinator : BaseCoordinator<Void> {
    private let navigationController : UINavigationController
    private let networkManager : NetworkClient
    init(with navigationController : UINavigationController,networkManager : NetworkClient) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = DetailChatViewController()
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
}

class ContactsCoordinator : BaseCoordinator<Void> {
    
    private let navigationController : UINavigationController
    private let networkManager : NetworkClient
    
    init(with navigationController : UINavigationController,networkManager : NetworkClient) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = ContactsViewController()
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
}

class SettingsCoordinator : BaseCoordinator<Void> {
    
    private let navigationController : UINavigationController
    private let sessionService : SessionService
    
    init(with navigationController : UINavigationController,sessionService : SessionService) {
        self.navigationController = navigationController
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<Void> {
        let viewController = SettingsViewController()
        let viewModel = SettingsViewModel(with: sessionService)
        viewController.viewModel = viewModel
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
}
