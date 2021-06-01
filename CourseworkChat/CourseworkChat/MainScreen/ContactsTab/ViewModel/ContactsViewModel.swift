//
//  ContactsViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 01.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

class ContactsViewModel : ViewModelType{
    
    var input: Input
    var output: Output
    
    private let disposeBag = DisposeBag()
    
    private let contactsService : ContactsService
    
    struct Input {
        let add : AnyObserver<Void>
        let reload : AnyObserver<Void>
    }
    
    struct Output {
        var contacts : Observable<[ContactCellViewModel]>
        let reload : Observable<Void>
        let addShow : Observable<Void>
    }
    
    
    private var contactsRelay : BehaviorRelay<[ContactCellViewModel]>
    private let reloadSubject = PublishSubject<Void>()
    private let addSubject = PublishSubject<Void>()
    
    
    init(with contactsService : ContactsService) {
        self.contactsService = contactsService
        
        let contacts = contactsService.getContacts()
        var models : [ContactCellViewModel] = []
        for contact in contacts {
            models.append(ContactCellViewModel(from: contact))
        }
        
        self.contactsRelay =  BehaviorRelay<[ContactCellViewModel]>(value : models)
        self.input = Input(add: addSubject.asObserver(), reload: reloadSubject.asObserver())
        self.output = Output(contacts: contactsRelay.asObservable(), reload: reloadSubject.asObservable(), addShow: addSubject.asObservable())
        
        receiveNewContact()
    }
    
    private func receiveNewContact(){
        
        self.contactsService.getNewContact = { [unowned self] contact in
            DispatchQueue.global().async(group: nil, qos: .utility, flags: .barrier, execute: {
                let model = ContactCellViewModel(from: contact)
                contactsRelay.accept([model] + contactsRelay.value)
            })
        }
    }
    
    deinit {
        self.contactsService.getNewContact = nil
    }
    
}
