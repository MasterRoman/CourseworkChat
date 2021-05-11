//
//  AuthorizationViewController.swift
//  CourseworkChat
//
//  Created by Admin on 11.05.2021.
//

import UIKit
import RxCocoa
import RxSwift

class AuthorizationViewController: UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLoginObserver()
        setupGestureRecognizers()
        
    }
    
    private func setupViews(){
        self.loginButton.layer.cornerRadius = 5.0
        self.loginButton.isEnabled = false
        self.loginButton.alpha = 0.5
    }
    
    private func setupGestureRecognizers(){
        let hideGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(hideGesture)
        
        hideGesture.rx.event.subscribe({ _ in
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func setupLoginObserver(){
        let nameValidation = self.loginTextField
            .rx.text
            .map({($0!.count > 6)})
            .share(replay: 1)
        
        let pwdValidation = passwordTextField
            .rx.text
            .map({($0!.count > 3)})
            .share(replay: 1)
        
        
        let enableButton = Observable.combineLatest(nameValidation, pwdValidation) { $0 && $1 }
            .share(replay: 1)
        
        enableButton.subscribe(onNext: { enabled in
            self.loginButton.alpha = enabled ? 0.8 : 0.5
            self.loginButton.isEnabled = enabled
        }).disposed(by: disposeBag)
        
    }
    
    private func setupBinding(){
        
    }
    
}
