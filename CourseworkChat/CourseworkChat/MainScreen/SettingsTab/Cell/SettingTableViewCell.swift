//
//  SettingTableViewCell.swift
//  CourseworkChat
//
//  Created by Admin on 13.05.2021.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet var settingIconImageView: UIImageView!
    @IBOutlet var settingTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        settingTitleLabel.text = nil
        settingIconImageView.image = nil
    }
    
    func configure(with model : SettingsOptions){
        settingTitleLabel.text = model.title
        settingIconImageView.image = model.icon
        if (model.type == .navigation){
            self.accessoryType = .disclosureIndicator
        }
    }
    
    static func getNibName()->String{
        return "SettingTableViewCell"
    }
    
    static func getId()->String{
        return "SettingId"
    }
    
}
