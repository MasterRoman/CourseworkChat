//
//  AuthCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift

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
    
        self.navigationController.pushViewController(viewController, animated: true)
        return self.sessionService.status.filter {$0!}.map { _ in Void() }.take(1)
    }
    
    private func showRegistrationCoordinator(with navigationController : UINavigationController){
        let registrationCoordinator = RegistrationCoordinator(with: navigationController, sessionService : sessionService)
        coordinate(to: registrationCoordinator)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.navigationController.isNavigationBarHidden = true
                self.navigationController.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}
