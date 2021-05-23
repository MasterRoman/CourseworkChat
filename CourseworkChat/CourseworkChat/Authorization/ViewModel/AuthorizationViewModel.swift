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
        let authorize : AnyObserver<Void>
        
        let login : AnyObserver<String?>
        let password : AnyObserver<String?>
    }
    
    struct Output {
        let registerShow : Observable<Void>
        let authorezeShow : Observable<Void>
        
        var enable : Observable<Bool>
    }
    
    
    private let registerSubject = PublishSubject<Void>()
    private let authorezeSubject = PublishSubject<Void>()
    private let loginSubject = PublishSubject<String?>()
    private let passwordSubject = PublishSubject<String?>()
    private let enableSubject = PublishSubject<Bool>()
    
    init() {
        self.output = Output(registerShow: registerSubject.asObservable(),
                             authorezeShow: authorezeSubject.asObservable(),
                             enable: enableSubject.asObservable())
        
        
        self.input = Input(register: registerSubject.asObserver(),
                           authorize: authorezeSubject.asObserver(),
                           login: loginSubject.asObserver(),
                           password: passwordSubject.asObserver())
        
        let loginValidation = loginSubject.asObservable()
            .map({($0!.count > 3)})
            .share(replay: 1)
        
        let passwordValidation = passwordSubject.asObservable()
            .map({($0!.count > 3)})
            .share(replay: 1)
        
        output.enable = Observable.combineLatest(loginValidation, passwordValidation) { $0 && $1 }
            .share(replay: 1)
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .authorization, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .authorization, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let credentials = notification.object as? Credentials {
            
        }
        
    }

    deinit {
        removeNotification()
    }
}
