//
//  AddChatViewController.swift
//  CourseworkChat
//
//  Created by Admin on 03.06.2021.
//

import UIKit
import RxSwift

class AddChatViewController: UIViewController {
    
    private var tableView : UITableView!
    
    var viewModel : AddChatViewModel!
    
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTableView()
        setupBackButton()
        setupAddButton()
    }
    
    private func setupBackButton(){
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.sizeToFit()
        
        button.rx
            .tap
            .bind(to: viewModel.input.back)
            .disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setupViews(){
        self.tableView = UITableView()
        
        self.view.addSubview(self.tableView)
        self.tableView.allowsMultipleSelection = true
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.navigationItem.title = "New Dialog"
    
    }
    
    private func setupAddButton(){
        
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.style = .plain
        rightBarButtonItem.title = "Next"
        
        rightBarButtonItem.rx
            .tap
            .bind(to: viewModel.input.next)
            .disposed(by: disposeBag)
        
        
        viewModel.output.selectedShow
            .map({$0.count > 0})
            .subscribe(onNext: { enabled in
                let alpha = enabled ? 1.0 : 0.8
                rightBarButtonItem.tintColor =  UIColor.systemBlue.withAlphaComponent(CGFloat(alpha))
                rightBarButtonItem.isEnabled = enabled
                
            })
            .disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func bindTableView() {
        tableView.register(UINib(nibName:AddChatTableViewCell.getNibName() , bundle: nil), forCellReuseIdentifier: AddChatTableViewCell.getId())
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.output.contacts
            .bind(to:tableView.rx.items(cellIdentifier: AddChatTableViewCell.getId(), cellType: AddChatTableViewCell.self)){row,viewModel,cell in
                cell.viewModel = viewModel
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ContactCellViewModel.self)
            .bind(to: viewModel.input.selected)
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeselected(ContactCellViewModel.self)
            .bind(to: viewModel.input.deselected)
            .disposed(by: disposeBag)
        
        
    }
    
}

extension AddChatViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = true
       
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}


