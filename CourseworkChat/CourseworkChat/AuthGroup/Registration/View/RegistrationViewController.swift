//
//  RegistrationViewController.swift
//  CourseworkChat
//
//  Created by Admin on 25.05.2021.
//

import UIKit
import RxSwift

enum RegistrationStage {
    case login
    case password
}

class RegistrationViewController : UIViewController {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var stage : RegistrationStage
    
    var viewModel : RegistrationViewModelType!
    
    init(with stage : RegistrationStage) {
        self.stage = stage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        if let stage = coder.decodeObject() as? RegistrationStage {
            self.stage = stage
        } else {
            return nil
        }
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestureRecognizers()
        setupUserNameObserver()
        
        setupBindings()
        setupBackButton()
    }
    
    private func setupViews(){
        self.nextButton.layer.cornerRadius = 5.0
        self.nextButton.isEnabled = false
        self.nextButton.alpha = 0.5
        
        switch self.stage {
        case .login:
            self.headerLabel.text = "Create username"
            self.descriptionLabel.text = "Choose a username for your new account"
            self.inputTextField.placeholder = "Username"
        case .password:
            self.headerLabel.text = "Create a password"
            self.descriptionLabel.text = "Don't tell anyone your password"
            self.inputTextField.placeholder = "Password"
        }
    }
    
    private func setupGestureRecognizers(){
        let hideGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(hideGesture)
        
        hideGesture.rx.event.subscribe({[weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    private func setupUserNameObserver(){
        self.inputTextField
            .rx.text
            .map({($0!.count > 3)})
            .share(replay: 1)
            .asObservable().subscribe(onNext: {[unowned self] enabled in
                self.nextButton.alpha = enabled ? 0.8 : 0.5
                self.nextButton.isEnabled = enabled
                
            }).disposed(by: disposeBag)
    }
    
    private func setupBindings(){
        nextButton.rx
            .tap
            .bind(to: viewModel.input.next)
            .disposed(by: disposeBag)
        
        inputTextField.rx
            .text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
    }
    
    private func setupBackButton(){
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("Back", for: .normal)
        button.sizeToFit()
        
        button.rx
            .tap
            .bind(to: viewModel.input.back)
            .disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

}

