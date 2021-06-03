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
    private let sessionService : SessionService
    
    init(with navigationController : UINavigationController,contactService : ContactsService,sessionService : SessionService) {
        self.navigationController = navigationController
        self.contactService = contactService
        self.sessionService = sessionService
    }
    
    override func start() -> Observable<Void> {
        let viewController = ContactsViewController()
        let viewModel = ContactsViewModel(with: contactService)
        viewController.viewModel = viewModel
        
        viewModel.output.addShow
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.showAddContactCoordinator(navigationController: self.navigationController)
                    .subscribe(onNext:{ isAddNewContact in
                        if (isAddNewContact){
                            //MARK: start indicator
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        
        self.navigationController.pushViewController(viewController, animated: true)
        return sessionService.status.filter{!$0!}.map { _ in Void() }
    }
    
    private func showAddContactCoordinator(navigationController : UINavigationController) -> Observable<Bool> {
        let addContactCoordinator = AddContactCoordinator(with: navigationController, contactService: contactService)
        return coordinate(to: addContactCoordinator)
            .map({ result in
                switch result{
                case .nickname:
                    return true
                case .cancel:
                    return false
                }
                
            })
    }
    
    deinit {
        print("Deinit")
    }
}
