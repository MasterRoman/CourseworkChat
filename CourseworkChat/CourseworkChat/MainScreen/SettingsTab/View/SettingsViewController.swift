//
//  SettingsViewController.swift
//  CourseworkChat
//
//  Created by Admin on 13.05.2021.
//

import UIKit
import RxSwift
import RxDataSources

class SettingsViewController: UIViewController {
    
    private var tableView : UITableView!
    private var userInfoHeaderView : UserInfoHeaderView!
    
    lazy var dataSource : RxTableViewSectionedReloadDataSource<Section> = {
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: { (_, tableView, indexPath, section) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.getId(), for: indexPath) as! SettingTableViewCell
            cell.configure(with: section)
            return cell
        })
        return dataSource
        
    }()
    
    private let disposeBag = DisposeBag()
    
    var viewModel : SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindTableView()
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
        
        self.userInfoHeaderView = UserInfoHeaderView(with: frame, name: viewModel.output.nickName, nickname: viewModel.output.nickName, icon: nil) 
        
        self.tableView.tableHeaderView = self.userInfoHeaderView
        self.tableView.tableFooterView = UIView()
        
        
       
    }
    
    private func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName:SettingTableViewCell.getNibName() , bundle: nil), forCellReuseIdentifier: SettingTableViewCell.getId())
        
        
        viewModel.output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
      
        
        
        tableView.rx.modelSelected(SettingsOptions.self)
            .bind(to: viewModel.input.selected)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] (indexPath) in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.configure()
    }
    
}

extension SettingsViewController : UITableViewDelegate{
    
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        let model = models[indexPath.section].options[indexPath.row]
    //        if (model.handler != nil){
    //            model.handler!()
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

