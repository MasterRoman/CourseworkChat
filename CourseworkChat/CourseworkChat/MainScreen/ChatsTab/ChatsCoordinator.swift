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
    
    private func showDetailChatCoordinator(with navigationController : UINavigationController) {
        let detailChatCoordinator = DetailChatCoordinator(with: navigationController, networkManager: networkManager)
        coordinate(to: detailChatCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
