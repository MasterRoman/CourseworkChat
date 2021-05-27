//
//  SessionService.swift
//  CourseworkChat
//
//  Created by Admin on 27.05.2021.
//

import Foundation
import RxSwift

class SessionService{
    let userManager : UserManager
    let networkManager : NetworkClient
    
    private let logOutSubject = PublishSubject<Void>()
    private let logInSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    var didLogOut: Observable<Void> {
        return logOutSubject.asObservable()
    }
    var didLogIn: Observable<Void> {
        return logInSubject.asObservable()
    }
    
    
    init(userManager : UserManager,networkManager : NetworkClient) {
        self.userManager = userManager
        self.networkManager = networkManager
    }
    
    func logIn(credentials : Credentials){
        do{
            try networkManager.send(message: .authorization(credentials: credentials))
        }
        catch
        {
            print("Connection error (SessionService)")
        }
    }
    
    func logOut(){
        userManager.logOut()
        logOutSubject.onNext(())
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .authorization, object: nil)
    }
    
    private func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: .authorization, object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification){
        if let credentials = notification.object as? Credentials {
            if (credentials.login == "APPROVED"){
                self.logInSubject.onNext(())
                if (!userManager.checkUserRegistration(login: credentials.login, password: credentials.password)){
                    userManager.registerUser(login: credentials.login, password: credentials.password, isActive: true)
                }
            }
            
        }
        
    }
    
    deinit {
        removeNotification()
    }
}
