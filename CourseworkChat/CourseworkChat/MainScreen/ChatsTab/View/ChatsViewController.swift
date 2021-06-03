//
//  ChatsViewController.swift
//  CourseworkChat
//
//  Created by Admin on 11.05.2021.
//

import UIKit
import RxSwift

class ChatsViewController: UIViewController {
    
    private var tableView : UITableView!
    
    var viewModel : ChatsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTableView()
        setupBindings()
        
    }
    
    private func setupViews(){
        self.tableView = UITableView()
        
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.navigationItem.title = "Chats"
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init()
        rightBarButtonItem.style = .plain
        rightBarButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    private func bindTableView() {
        tableView.register(UINib(nibName:ChatTableViewCell.getNibName() , bundle: nil), forCellReuseIdentifier: ChatTableViewCell.getId())
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ChatCellViewModel.self)
            .bind(to: viewModel.input.selected)
            .disposed(by: disposeBag)
        
        viewModel.output.chats
            .bind(to:tableView.rx.items(cellIdentifier: ChatTableViewCell.getId(), cellType: ChatTableViewCell.self)){row,item,cell in
                cell.viewModel = item
            }.disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [unowned self] (indexPath) in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func setupBindings(){
        viewModel.output.reload
            .subscribe(onNext: { [unowned self] in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    deinit {
        print("DEINIT")
    }
    
}

extension ChatsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
