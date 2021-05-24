//
//  AuthorizationViewModel.swift
//  CourseworkChat
//
//  Created by Admin on 17.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

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
    
    private let disposeBag = DisposeBag()
    
    let networkManager : NetworkClient
    
    struct Input {
        let register : AnyObserver<Void>
        let authorize : AnyObserver<Void>
        
        let login : AnyObserver<String>
        let password : AnyObserver<String>
    }
    
    struct Output {
        let registerShow : Observable<Void>
        let authorezeShow : Observable<Void>
        
        var enable : Observable<Bool>
    }
    
    
    private let registerSubject = PublishSubject<Void>()
    private let authorezeSubject = PublishSubject<Void>()
    private let loginSubject = BehaviorSubject<String>(value: "")
    private let passwordSubject = BehaviorSubject<String>(value: "")
    private let enableSubject = PublishSubject<Bool>()
    
    init(with networkManager : NetworkClient) {
        self.networkManager = networkManager
        
        self.output = Output(registerShow: registerSubject.asObservable(),
                             authorezeShow: authorezeSubject.asObservable(),
                             enable: enableSubject.asObservable())
        
        
        self.input = Input(register: registerSubject.asObserver(),
                           authorize: authorezeSubject.asObserver(),
                           login: loginSubject.asObserver(),
                           password: passwordSubject.asObserver())
        
        let loginValidation = loginSubject.asObservable()
            .map({($0.count > 3)})
            .share(replay: 1)
        
        let passwordValidation = passwordSubject.asObservable()
            .map({($0.count > 3)})
            .share(replay: 1)
        
        output.enable = Observable.combineLatest(loginValidation, passwordValidation) { $0 && $1 }
            .share(replay: 1)
        
        output.authorezeShow.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let credentials = Credentials(login: try self.loginSubject.value(), password: try self.passwordSubject.value())
                    try self.networkManager.send(message: .authorization(credentials: credentials ))
                }
                catch (let error){
                    print(error)
                    return
                }
            }
            
        }).disposed(by: disposeBag)
        
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
