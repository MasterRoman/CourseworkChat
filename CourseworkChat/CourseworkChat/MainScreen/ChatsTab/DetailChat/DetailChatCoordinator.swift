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
    private let networkManager : NetworkClient
    init(with chat : Chat,navigationController : UINavigationController,networkManager : NetworkClient) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    override func start() -> Observable<Void> {
        let viewController = DetailChatViewController()
        let viewModel = DetailChatViewModel()
        viewController.viewModel = viewModel
        self.navigationController.pushViewController(viewController, animated: true)
        return viewModel.output.back
    }
}
