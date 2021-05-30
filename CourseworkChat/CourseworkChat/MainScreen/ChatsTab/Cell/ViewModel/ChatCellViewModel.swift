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
    var icon : UIImage?
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
        self.dialogTitle = chat.senders.last!.displayName
        self.lastMessagePreview = chat.chatBody.messages.last?.kind.getValue() ?? ""
       
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        self.lastMessageTime = formatter.string(from:chat.chatBody.messages.last!.sentDate)
    }
    
    mutating func configure(with body: ChatBody){
        let message = body.messages.last
        self.lastMessagePreview = (message?.kind.getValue())!
        self.lastMessageTime = getString(from: message!.sentDate)
        
    }
    
    private func getString(from date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from:date)
    }
}
