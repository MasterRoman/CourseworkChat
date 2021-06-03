//
//  SceneCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift

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
                        navigationController.popToRootViewController(animated: false)
                        navigationController.viewControllers.removeAll()
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
