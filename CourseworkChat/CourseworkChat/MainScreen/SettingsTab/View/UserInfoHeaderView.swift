//
//  UserInfoHeaderView.swift
//  CourseworkChat
//
//  Created by Admin on 13.05.2021.
//

import UIKit

class UserInfoHeaderView: UIView {
    
    var profileImageView: UIImageView
    
    var usernameLabel: UILabel
    var nicknameLabel : UILabel
    
    init(with frame: CGRect,name : String,nickname : String,icon : UIImage?) {
        self.profileImageView = UIImageView()
        self.usernameLabel = UILabel()
        self.nicknameLabel = UILabel()
        super.init(frame: frame)
        
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = 100 / 2.0 //MARK: !!!!
        self.profileImageView.clipsToBounds = true
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
       
        
        if (icon != nil){
            self.profileImageView.image = icon!
        }
        else
        {
            self.profileImageView.image = UIImage(systemName: "person")
            self.profileImageView.backgroundColor = .systemFill
            self.profileImageView.tintColor = .label
        }
        
        self.addSubview(self.profileImageView)
        NSLayoutConstraint.activate([
            self.profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor , constant: 12),
            self.profileImageView.widthAnchor.constraint(equalToConstant: 100),  //MARK: !!!!
            self.profileImageView.heightAnchor.constraint(equalToConstant: 100) //MARK: !!!!
        ])
        

        self.usernameLabel.text = name
        self.usernameLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameLabel)

        NSLayoutConstraint.activate([
            self.usernameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.usernameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor , constant: 8),
        ])
        
        self.nicknameLabel.text = nickname
        self.nicknameLabel.font = UIFont.systemFont(ofSize: 16)
        self.nicknameLabel.textColor = .secondaryLabel
        self.nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nicknameLabel)

        NSLayoutConstraint.activate([
            self.nicknameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.nicknameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            self.nicknameLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor.opaqueSeparator
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            bottomSeparator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomSeparator.heightAnchor .constraint(equalToConstant: 1),
        ])

    }
    
    func update(with name : String?,nickname : String?,icon : UIImage?){
        if (name != nil){
            self.usernameLabel.text = name!
        }
        if (nickname != nil ){
            self.nicknameLabel.text = nickname!
        }
        if (icon != nil){
            self.profileImageView.image = icon!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
