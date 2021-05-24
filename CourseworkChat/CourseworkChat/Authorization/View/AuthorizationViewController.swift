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
    @IBOutlet var signUpButton: UIButton!
    
    var viewModel : AuthorizationViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLoginObserver()
        setupGestureRecognizers()
        setupBinding()
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
       
        viewModel.output.enable
            .subscribe(onNext: { enabled in
            self.loginButton.alpha = enabled ? 0.8 : 0.5
            self.loginButton.isEnabled = enabled
        }).disposed(by: disposeBag)
        
    }
    
    private func setupBinding(){
        signUpButton.rx
            .tap
            .bind(to: viewModel.input.register)
            .disposed(by: disposeBag)
        
        loginButton.rx
            .tap
            .bind(to: viewModel.input.authorize)
            .disposed(by: disposeBag)
        
        loginTextField.rx
            .text.orEmpty
            .bind(to: viewModel.input.login)
            .disposed(by: disposeBag)
        
        passwordTextField.rx
            .text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
    }
    
}
