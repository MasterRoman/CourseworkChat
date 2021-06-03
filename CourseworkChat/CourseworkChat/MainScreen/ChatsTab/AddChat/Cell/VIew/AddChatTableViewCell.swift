//
//  AddChatTableViewCell.swift
//  CourseworkChat
//
//  Created by Admin on 04.06.2021.
//

import UIKit

class AddChatTableViewCell: UITableViewCell {
    //●⚪️🔘⚫️◎⦿◉◎
    override var isSelected: Bool {
        didSet {
            checkmarkLabel.text = isSelected ? "◉" : "◎"
        }
    }
    
    var viewModel : ContactCellViewModel!{
        didSet{
            configure()
        }
    }
    
    @IBOutlet var checkmarkLabel: UILabel!
    @IBOutlet var userIconImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    private func setupViews(){
        userIconImageView.layer.borderWidth = 1.0
        userIconImageView.layer.masksToBounds = false
        userIconImageView.layer.borderColor = UIColor.white.cgColor
        userIconImageView.layer.cornerRadius = userIconImageView.frame.size.width / 2
        userIconImageView.clipsToBounds = true
    }
    
    private func configure() {
        userIconImageView.image = viewModel.icon
        nicknameLabel.text = viewModel.name
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getNibName()->String{
        return "AddChatTableViewCell"
    }
    
    static func getId()->String{
        return "ContactToChatId"
    }
    
}
