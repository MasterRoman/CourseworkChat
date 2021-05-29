//
//  SettingsCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift

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
