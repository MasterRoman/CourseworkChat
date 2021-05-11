//
//  ChatTableViewCell.swift
//  CourseworkChat
//
//  Created by Admin on 12.05.2021.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    
    @IBOutlet var dialogIconImageView: UIImageView!
    @IBOutlet var dialogTitleLabel: UILabel!
    @IBOutlet var lastMessagePreviewLabel: UILabel!
    @IBOutlet var lastMessageTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    static func getNibName()->String{
        return "ChatTableViewCell"
    }
    
    static func getId()->String{
        return "ChatId"
    }
    
}
