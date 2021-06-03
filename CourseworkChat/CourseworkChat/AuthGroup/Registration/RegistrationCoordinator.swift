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
        
        navigationController.isNavigationBarHidden = false
        self.navigationController.pushViewController(viewController, animated: true)
        
        viewModel.output.isSuccess        ////////////FIX!
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self,weak viewModel] success in
                if (success){
                    guard let self = self else {return}
                    let passwordViewController = RegistrationViewController(with: .password)
                    let passwordViewModel = RegistrationPasswordViewModel(with: viewModel!.login ,sessionService: self.sessionService)
                    passwordViewController.viewModel = passwordViewModel
                    
                    self.navigationController.pushViewController(passwordViewController, animated: true)
                    
                    passwordViewModel.output.back.subscribe(onNext: { [weak self] in
                        self?.navigationController.popViewController(animated: true)
                    }).disposed(by: self.disposeBag)
                    
                    passwordViewModel.output.isSuccess
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [weak self,weak viewModel] success in
                            if (success){
                                guard let self = self else {return}
                                self.navigationController.isNavigationBarHidden = true
                                self.navigationController.popToRootViewController(animated: true)
                                viewModel?.input.back.onNext(())
                            }
                        }).disposed(by: self.disposeBag)
                }
            }).disposed(by: disposeBag)
        
        
        return viewModel.output.back
    }
}
