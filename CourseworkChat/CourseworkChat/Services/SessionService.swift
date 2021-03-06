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
    private var credentials : Credentials?
    
    var status : Observable<Bool?> {
        return statusSubject.asObservable()
    }
    
    var error : (() -> ())?
    
    
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
                
                self.credentials = credentials
            }
            catch
            {
                self.statusSubject.onNext(false)
                print("Connection error (SessionService)")
            }
        }
    }
    
    func logOut(){
        sendOffline()
        userManager.logOut()
        statusSubject.onNext(false)
    }
    
    private func sendOffline(){
        do{
            try self.networkManager.send(message: .offline(login: credentials!.login))
        }
        catch
        {
            print("error")
            return
        }
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
               
                DispatchQueue.global(qos: .background).async {
                    guard let locCredentials = self.credentials else {
                        return
                    }
                    
                    if (!self.userManager.checkUserRegistration(login: locCredentials.login, password: locCredentials.password)){
                        self.userManager.registerUser(login:locCredentials.login, password:locCredentials.password, isActive: true)
                    }
                }
                
                self.statusSubject.onNext(true)
                
            }
            else
            {
                self.error?()
                //self.statusSubject.onNext(false)
            }
            
        }
        
    }
    
    deinit {
        removeNotification()
        self.error = nil
    }
}
