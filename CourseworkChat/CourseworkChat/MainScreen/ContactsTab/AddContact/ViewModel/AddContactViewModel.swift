//
//  AddContactViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 01.06.2021.
//

import Foundation
import RxSwift

class AddContactViewModel : ViewModelType{
    var input: Input
    var output: Output
    
    private let disposeBag = DisposeBag()
    
    private let contactsService : ContactsService
    
    struct Input {
        let add : AnyObserver<Void>
        let cancel : AnyObserver<Void>
        let text : AnyObserver<String>
    }
    
    struct Output {
        let addShow : Observable<Void>
        let cancelShow : Observable<Void>
        var login : Observable<String>
    }
    
    
    private let cancelSubject = PublishSubject<Void>()
    private let textSubject =  BehaviorSubject<String>(value: "")
    private let addSubject = PublishSubject<Void>()

    
    init(with contactsService : ContactsService) {
        self.contactsService = contactsService
        
        self.input = Input(add: addSubject.asObserver(), cancel: cancelSubject.asObserver(), text: textSubject.asObserver())
        self.output = Output(addShow: addSubject.asObservable(), cancelShow: cancelSubject.asObservable(),login: textSubject.asObservable())
        
        output.addShow.subscribe(onNext: { [unowned self] in
            do{
                let nickname = try textSubject.value()
                contactsService.addNewContact(login: nickname)
            }catch{
                return
            }
        }).disposed(by: disposeBag)
        
    }
}




