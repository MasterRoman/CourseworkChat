//
//  AddContactAlertController.swift
//  CourseworkChat
//
//  Created by Admin on 01.06.2021.
//

import UIKit
import RxSwift

class AddContactController : UIAlertController {
    
    private let disposeBag = DisposeBag()
    
    var viewModel : AddContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndBindings()
    }
    
    
    
    private func setupViewsAndBindings(){
        self.title = "Add contact"
        
        let addAction = UIAlertAction(title: "Add", style: .default){ [weak self] _ in
            self?.viewModel.input.add.onNext(())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ [weak self] _ in
            self?.viewModel.input.cancel.onNext(())
        }
        
        
        self.addTextField { [weak self] (textField) in
            guard let self = self else {return}
            textField.placeholder = "Nickname"
            textField.rx
                .text.orEmpty
                .bind(to: self.viewModel.input.text)
                .disposed(by: self.disposeBag)
        }
        
        self.addAction(addAction)
        self.addAction(cancelAction)
    }

}
