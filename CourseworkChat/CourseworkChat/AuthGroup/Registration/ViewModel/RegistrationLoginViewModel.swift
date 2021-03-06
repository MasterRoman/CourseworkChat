//
//  RegistrationLoginViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 18.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationLoginViewModel : RegistrationViewModelType{
    
    
    var input: Input
    var output: Output
    
    private let networkManager : NetworkClient
  
    
    private let disposeBag = DisposeBag()
    
    private let nextSubject = PublishSubject<Void>()
    private let textSubject = BehaviorSubject<String>(value: "")
    private let successSubject = PublishSubject<Bool>()
    private let errorSubject = BehaviorSubject<String>(value: "")
    private let backSubject = PublishSubject<Void>()
    
    var login = ""
    
    init(with networkManager : NetworkClient) {
        self.networkManager = networkManager
        
        
        self.input = Input(next: nextSubject.asObserver(), text: textSubject.asObserver(), back: backSubject.asObserver())
        
       
        self.output = Output(nextShow: nextSubject.asObservable(), isSuccess: successSubject.asObservable(), back: backSubject.asObservable())
        
        self.output.nextShow.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let login = try self.textSubject.value()
                    try self.networkManager.send(message: .checkLogin(login: login))
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .checkLogin, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .registration, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let login = notification.object as? String {
            if login != "BUSY"{
                self.login = login
                self.successSubject.onNext(true)
            }
            else
            {
                self.successSubject.onNext(false)
            }
            
        }
        
    }
    
    deinit {
        removeNotification()
    }
}
