//
//  AuthorizationViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 17.05.2021.
//

import Foundation
import RxSwift

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
//
//  func transform(input: Input) -> Output
    var input: Input { get }
    var output: Output { get }
}

class AuthorizationViewModel : ViewModelType {

    var input: Input
    var output: Output
    
    struct Input {
        let register : AnyObserver<Void>
    }
    
    struct Output {
        let registerShow : Observable<Void>
    }
    
    
    private let registerSubject = PublishSubject<Void>()
    
    init() {
        let output = registerSubject.asObservable()
        
        self.output = Output(registerShow: output)
        
        self.input = Input(register: registerSubject.asObserver())
    }
}
