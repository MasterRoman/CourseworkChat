//
//  ChatsViewController.swift
//  CourseworkChat
//
//  Created by Admin on 11.05.2021.
//

import UIKit

class ChatsViewController: UIViewController {
    
    private var tableView : UITableView!
    
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
        
        self.navigationItem.title = "Chats"
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init()
        rightBarButtonItem.style = .plain
        rightBarButtonItem.image = UIImage(systemName: "square.and.pencil")
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    private func bindTableView() {
        tableView.register(UINib(nibName:ChatTableViewCell.getNibName() , bundle: nil), forCellReuseIdentifier: ChatTableViewCell.getId())
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension ChatsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.getId(), for: indexPath) as! ChatTableViewCell
        cell.dialogTitleLabel.text = "HEllo"
        cell.lastMessagePreviewLabel.text = "sdasdasdasd"
        cell.lastMessageTimeLabel.text = "12:55"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 70
       }
}
