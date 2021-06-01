//
//  AddContactCoordinator.swift
//  CourseworkChat
//
//  Created by Admin on 01.06.2021.
//

import Foundation
import RxSwift

enum AddContactCoordinatorResult{
    case nickname
    case cancel
}

class AddContactCoordinator : BaseCoordinator<AddContactCoordinatorResult> {
    
    private let navigationController : UINavigationController
    private let contactService : ContactsService
    
    init(with navigationController : UINavigationController,contactService : ContactsService) {
        self.navigationController = navigationController
        self.contactService = contactService
    }
    
    override func start() -> Observable<AddContactCoordinatorResult> {
        let viewController = AddContactController(title: "", message: "", preferredStyle: .alert)
        let viewModel = AddContactViewModel(with: contactService)
        viewController.viewModel = viewModel
        
        let cancel = viewModel.output.cancelShow.map{_ in AddContactCoordinatorResult.cancel}
        let nickname = viewModel.output.addShow.map{_ in AddContactCoordinatorResult.nickname}
        
        
        self.navigationController.present(viewController, animated: true, completion: nil)
        
        return Observable.merge(cancel,nickname)
            .take(1)
            .do(onNext: { [weak self] _ in
                self?.navigationController.dismiss(animated: true)
            })
    }
}
