//
//  AddChatViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 03.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

class AddChatViewModel : ViewModelType{
 
    var input: Input
    var output: Output
    
    private let contactsService : ContactsService
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let back : AnyObserver<Void>
        let selected : AnyObserver<ContactCellViewModel?>
        let deselected : AnyObserver<ContactCellViewModel?>
        let next : AnyObserver<Void>
    }
    
    struct Output {
        let back : Observable<Void>
        var selectedhShow : Observable<[ContactCellViewModel]>
        var contacts : Observable<[ContactCellViewModel]>
        let next : Observable<Void>
    }
    
    
    private let chatService : ChatService
    
    private let deselectedCell = BehaviorSubject<ContactCellViewModel?>(value: nil)
    private let selectedCell = BehaviorSubject<ContactCellViewModel?>(value: nil)
    private let selectedCells = BehaviorRelay<[ContactCellViewModel]>(value: [])
    private var contactsRelay : BehaviorRelay<[ContactCellViewModel]>
    private let nextSubject = PublishSubject<Void>()
    private let backSubject = PublishSubject<Void>()
    
    init(chatService : ChatService,contactsService : ContactsService) {
        self.chatService = chatService
        self.contactsService = contactsService
        
        let contacts = contactsService.getContacts()
        var models : [ContactCellViewModel] = []
        for contact in contacts {
            models.append(ContactCellViewModel(from: contact))
        }
        
        self.contactsRelay = BehaviorRelay<[ContactCellViewModel]>(value: models)
        
        self.input = Input(back: backSubject.asObserver(), selected: selectedCell.asObserver(), deselected: deselectedCell.asObserver(), next: nextSubject.asObserver())
        self.output = Output(back: backSubject.asObservable(), selectedhShow: selectedCells.asObservable(), contacts: contactsRelay.asObservable(), next: nextSubject.asObservable())
        
        newSelectedCell()
        newDeselectedCell()
    }
    
    private func newSelectedCell(){
        self.selectedCell.asObservable()
            .subscribe(onNext: { [unowned self] cell in
                guard let newCell = cell else {return}
                self.selectedCells.accept(self.selectedCells.value + [newCell])
            
            }).disposed(by: disposeBag)
    }
    
    private func newDeselectedCell(){
        self.deselectedCell.asObservable()
            .subscribe(onNext: { [unowned self] cell in
                guard let newCell = cell else {return}
                
                var cells = self.selectedCells.value
                if let index = cells.firstIndex(where: {$0.name == newCell.name}) {
                    cells.remove(at: index)
                }
                self.selectedCells.accept(cells)
            
            }).disposed(by: disposeBag)
    }
    
    
}
