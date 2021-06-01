//
//  AddContactAlertController.swift
//  CourseworkChat
//
//  Created by Admin on 01.06.2021.
//

import UIKit
import RxSwift

class AddContactAlertController: UIAlertController {
    
    var addButton : UIAlertAction!
    var cancelButton : UIAlertAction!
    var textField : UITextField!
    
    private let disposeBag = DisposeBag()
    
    var viewModel : AddContactViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }
    
    
    
    private func setupViews(){
        self.title = "Add contact"
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addButton)
        self.addButton = addButton
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cancelButton)
        self.cancelButton = cancelButton
        
        let textField = UITextField()
        textField.placeholder = "Login"
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.textField = textField
        
        self.textFields?.append(self.textField)
        
        let action = UIAlertAction()
        self.addAction(<#T##action: UIAlertAction##UIAlertAction#>)
    }
    
    
    private func setupBindings(){
        self.addButton.rx
            .tap
            .bind(to: viewModel.input.add)
            .disposed(by: disposeBag)
        
        self.cancelButton.rx
            .tap
            .bind(to: viewModel.input.cancel)
            .disposed(by: disposeBag)
        
        self.textField.rx
            .text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposeBag)
    }
    
    

}
