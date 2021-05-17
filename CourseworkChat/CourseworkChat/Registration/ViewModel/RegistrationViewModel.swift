//
//  RegistrationViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 18.05.2021.
//

import Foundation
import RxSwift

class RegistrationViewModel : ViewModelType{
    var input: Input
    var output: Output
    
    struct Input {
        let next : AnyObserver<Void>
    }
    
    struct Output {
        let nextShow : Observable<Void>
    }
    
    
    private let nextSubject = PublishSubject<Void>()
    
    init() {
        let output = nextSubject.asObservable()
        
        self.output = Output(nextShow: output)
        
        self.input = Input(next: nextSubject.asObserver())
    }
}
