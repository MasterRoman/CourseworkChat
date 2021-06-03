//
//  ContactsViewController.swift
//  CourseworkChat
//
//  Created by Admin on 12.05.2021.
//

import UIKit
import RxSwift

class ContactsViewController: UIViewController {
    
    private var tableView : UITableView!
    private var searchController : UISearchController!
    
    var viewModel : ContactsViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTableView()
        
        setupAddButton()
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
        
        self.navigationItem.title = "Contacts"
       
        
        self.searchController = UISearchController()
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.placeholder = "Search"
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
    
        
        self.searchController.searchBar.delegate = self //MARK: FIX
    }
    
    private func setupAddButton(){
        
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.style = .plain
        rightBarButtonItem.image = UIImage(systemName: "plus")
       
        rightBarButtonItem.rx
            .tap
            .bind(to: viewModel.input.add)
            .disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func bindTableView() {
        tableView.register(UINib(nibName:ContactsTableViewCell.getNibName() , bundle: nil), forCellReuseIdentifier: ContactsTableViewCell.getId())
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.output.contacts
            .bind(to:tableView.rx.items(cellIdentifier: ContactsTableViewCell.getId(), cellType: ContactsTableViewCell.self)){row,viewModel,cell in
                cell.viewModel = viewModel
            }.disposed(by: disposeBag)
    }
    
}

extension ContactsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


extension ContactsViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsCancelButton = false
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsCancelButton = false
        self.searchController.searchBar.text = ""
        self.searchController.searchBar.resignFirstResponder()
    }
}
