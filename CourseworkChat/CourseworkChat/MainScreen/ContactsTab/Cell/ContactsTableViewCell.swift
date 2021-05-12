//
//  ContactsTableViewCell.swift
//  CourseworkChat
//
//  Created by Admin on 12.05.2021.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    @IBOutlet var contactIconImageView: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        // Initialization code
    }

    private func setupViews(){
        contactIconImageView.layer.borderWidth = 1.0
        contactIconImageView.layer.masksToBounds = false
        contactIconImageView.layer.borderColor = UIColor.white.cgColor
        contactIconImageView.layer.cornerRadius = contactIconImageView.frame.size.width / 2
        contactIconImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getNibName()->String{
        return "ContactsTableViewCell"
    }
    
    static func getId()->String{
        return "ContactId"
    }
    
}
