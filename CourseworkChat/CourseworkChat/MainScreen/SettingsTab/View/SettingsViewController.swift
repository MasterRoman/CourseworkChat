//
//  SettingsViewController.swift
//  CourseworkChat
//
//  Created by Admin on 13.05.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var tableView : UITableView!
    private var userInfoHeaderView : UserInfoHeaderView!
    
    private var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTableView()
        configure()
    }
    
    private func configure(){
        self.models.append(Section(title: "", options: [SettingsOptions(title: "Edit profile", icon: UIImage(systemName: "person"), type: .navigation, handler: nil)]))
        self.models.append(Section(title: "", options: [SettingsOptions(title: "About app", icon: UIImage(systemName: "questionmark.circle"), type: .navigation, handler: nil)]))
        self.models.append(Section(title: "", options: [SettingsOptions(title: "Log out", icon: nil, type: .button, handler: nil)]))
      
        
    }
    
    private func setupViews(){
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.navigationItem.title = "Settings"
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 190)
        self.userInfoHeaderView = UserInfoHeaderView(with: frame, name: "Roman Kozko", nickname: "romuald", icon: nil) //MARK: FIX IT
        self.tableView.tableHeaderView = self.userInfoHeaderView
        self.tableView.tableFooterView = UIView()
    }
    
    private func bindTableView() {
        tableView.register(UINib(nibName:SettingTableViewCell.getNibName() , bundle: nil), forCellReuseIdentifier: SettingTableViewCell.getId())
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.getId(), for: indexPath) as! SettingTableViewCell
        let model = models[indexPath.section].options[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        if (model.handler != nil){
            model.handler!()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

