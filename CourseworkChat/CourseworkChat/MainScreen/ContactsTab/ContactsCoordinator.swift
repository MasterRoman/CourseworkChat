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
    private let contactService : ContactsService
    
    init(with navigationController : UINavigationController,contactService : ContactsService) {
        self.navigationController = navigationController
        self.contactService = contactService
    }
    
    override func start() -> Observable<Void> {
        let viewController = ContactsViewController()
        let viewModel = ContactsViewModel(with: contactService)
        viewController.viewModel = viewModel
        self.navigationController.pushViewController(viewController, animated: true)
        return Observable.never()
    }
}
