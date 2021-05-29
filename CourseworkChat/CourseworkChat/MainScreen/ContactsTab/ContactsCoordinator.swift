//
//  ContactsCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 29.05.2021.
//

import Foundation
import RxSwift

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
