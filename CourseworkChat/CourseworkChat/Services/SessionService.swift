//
//  SessionService.swift
//  CourseworkChat
//
//  Created by Admin on 27.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

class SessionService{
    let userManager : UserManager
    let networkManager : NetworkClient
    
    private let statusSubject : BehaviorSubject<Bool?>
    private let disposeBag = DisposeBag()
    
    var status : Observable<Bool?> {
        return statusSubject.asObservable()
    }
    
    
    
    init(userManager : UserManager,networkManager : NetworkClient) {
        self.userManager = userManager
        self.networkManager = networkManager
        
        self.statusSubject = userManager.checkUserStatus() ?  BehaviorSubject<Bool?>(value: nil) : BehaviorSubject<Bool?>(value: false)
    
        checkAuth()
        registerNotification()
    }
    
    private func checkAuth(){
        if (userManager.checkUserStatus()){
            let data = userManager.getUserInfo()
            let login = data!["Login"] as! String
            let password = data!["Password"] as! String
            let credentials = Credentials(login: login, password: password)
            logIn(credentials: credentials)
        }
        else
        {
            statusSubject.onNext(false)
        }
    }
    
    func logIn(credentials : Credentials){
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            do{
                try self.networkManager.send(message: .authorization(credentials: credentials))
                self.userManager.checkUserRegistration(login: credentials.login, password: credentials.password)
            }
            catch
            {
                self.statusSubject.onNext(false)
                print("Connection error (SessionService)")
            }
        }
    }
    
    func logOut(){
        userManager.logOut()
        statusSubject.onNext(false)
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
                self.statusSubject.onNext(true)
              
            }
            else
            {
                self.statusSubject.onNext(false)
            }
            
        }
        
    }
    
    deinit {
        removeNotification()
    }
}
