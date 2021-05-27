//
//  RegistrationPasswordViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 25.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationPasswordViewModel : RegistrationViewModelType{
    
    var input: Input
    var output: Output
    
    private let sessionService : SessionService
    private let disposeBag = DisposeBag()
    

    private let login : String
    
    private let nextSubject = PublishSubject<Void>()
    private let textSubject = BehaviorSubject<String>(value: "")
    private let successRelay = BehaviorRelay<Bool>(value: false)
    
    init(with login : String,sessionService : SessionService) {
        self.login = login
        self.sessionService = sessionService
        
        
        self.output = Output(nextShow: nextSubject.asObservable(), isSuccess: successRelay.asObservable())
        
        self.input = Input(next: nextSubject.asObserver(), text: textSubject.asObserver())
        
        self.output.nextShow.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let credentials = Credentials(login: login, password: try self.textSubject.value())
                    try self.sessionService.networkManager.send(message: .registration(credentials: credentials))
                }
                catch (let error){
                    print(error)
                    return
                }
            }
            
        }).disposed(by: disposeBag)
        
        registerNotification()
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .registration, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .registration, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let credentials = notification.object as? Credentials {
            if (credentials.login == login){
                self.successRelay.accept(true)
                self.sessionService.userManager.registerUser(login: login, password: credentials.password, isActive: true)
            }
            
        }
        
    }

    deinit {
        removeNotification()
    }
}
