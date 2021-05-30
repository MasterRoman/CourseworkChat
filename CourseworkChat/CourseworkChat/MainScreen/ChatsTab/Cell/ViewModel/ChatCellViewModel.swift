//
//  ChatCellModel.swift
//  CourseworkChat
//
//  Created by Admin on 30.05.2021.
//

import Foundation
import UIKit

struct ChatCellViewModel {
    let chatId : UUID
    let icon : UIImage?
    var dialogTitle : String
    var lastMessagePreview: String
    var lastMessageTime: String
    
    init(with id : UUID,icon : UIImage?,dialogTitle : String,lastMessagePreview: String = "",lastMessageTime: String = "") {
        self.chatId = id
        self.icon = icon
        self.dialogTitle = dialogTitle
        self.lastMessagePreview = lastMessagePreview
        self.lastMessageTime = lastMessageTime
    }
    
    init(from chat : Chat) {
        self.chatId = chat.chatBody.chatId
        self.icon = nil
        self.dialogTitle = chat.senders[1].displayName
        self.lastMessagePreview = chat.chatBody.messages.last?.kind.getValue() ?? ""
       
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        self.lastMessageTime = formatter.string(from:chat.chatBody.messages.last!.sentDate)
    }
}
