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
    
    init(from chat : Chat,sender : Sender) {
        self.chatId = chat.chatBody.chatId
        self.icon = nil
        
        let senders = chat.senders
        
        if (senders.count > 2){
            self.dialogTitle = senders.map({$0.displayName}).joined(separator: "+")
        }
        else
        {
            self.dialogTitle = senders.first(where: {$0.displayName != sender.displayName})!.displayName
        }
        
        self.lastMessagePreview = chat.chatBody.messages.last?.kind.getValue() ?? ""
        
        if (chat.chatBody.messages.last != nil){
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            self.lastMessageTime = formatter.string(from:chat.chatBody.messages.last!.sentDate)
        }
        else
        {
            self.lastMessageTime = "NONE"
        }
    }
    
    mutating func configure(with body: ChatBody){
        let lastMessage = body.messages.last
        guard let message = lastMessage else {
            self.lastMessagePreview = "Empty"
            self.lastMessageTime = "None"
            return
        }
        self.lastMessagePreview = (message.kind.getValue())
        self.lastMessageTime = getString(from: message.sentDate)
        
    }
    
    private func getString(from date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from:date)
    }
}
