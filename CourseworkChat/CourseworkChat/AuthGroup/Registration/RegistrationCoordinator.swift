//
//  RegistrationCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift

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
}
