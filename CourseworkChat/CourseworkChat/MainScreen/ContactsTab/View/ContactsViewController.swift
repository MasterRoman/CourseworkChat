//
//  ContactsViewController.swift
//  CourseworkChat
//
//  Created by Admin on 12.05.2021.
//

import UIKit

class ContactsViewController: UIViewController {
    
    private var tableView : UITableView!
    private var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTableView()
        
        
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
        
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.style = .plain
        rightBarButtonItem.image = UIImage(systemName: "plus")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        self.searchController = UISearchController()
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.placeholder = "Search"
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
    
        
        self.searchController.searchBar.delegate = self //MARK: FIX
    }
    
    private func bindTableView() {
        tableView.register(UINib(nibName:ContactsTableViewCell.getNibName() , bundle: nil), forCellReuseIdentifier: ContactsTableViewCell.getId())
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension ContactsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.getId(), for: indexPath) as! ContactsTableViewCell
        cell.contactNameLabel.text = "Roma"
        return cell
    }
    
    
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
