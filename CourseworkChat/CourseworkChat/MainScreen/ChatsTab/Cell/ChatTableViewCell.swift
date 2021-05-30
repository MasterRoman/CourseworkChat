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
    
    var viewModel: ChatCellViewModel! {
        didSet {
            self.configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    private func configure() {
        dialogIconImageView.image = viewModel.icon
        dialogTitleLabel.text = viewModel.dialogTitle
        lastMessagePreviewLabel.text = viewModel.lastMessagePreview
        lastMessageTimeLabel.text = viewModel.lastMessageTime
        
        
    }
    
    private func setupViews(){
        dialogIconImageView.layer.borderWidth = 1.0
        dialogIconImageView.layer.masksToBounds = false
        dialogIconImageView.layer.borderColor = UIColor.white.cgColor
        dialogIconImageView.layer.cornerRadius = dialogIconImageView.frame.size.width / 2
        dialogIconImageView.clipsToBounds = true
    }
    
    static func getNibName()->String{
        return "ChatTableViewCell"
    }
    
    static func getId()->String{
        return "ChatId"
    }
    
}
