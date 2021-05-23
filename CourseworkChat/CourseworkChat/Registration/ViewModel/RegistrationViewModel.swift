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
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .registration, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .registration, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let credentials = notification.object as? Credentials {
            
        }
        
    }

    deinit {
        removeNotification()
    }
}
