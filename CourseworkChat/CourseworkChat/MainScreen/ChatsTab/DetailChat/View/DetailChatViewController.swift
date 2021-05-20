//
//  ChatViewController.swift
//  CourseworkChat
//
//  Created by Admin on 15.05.2021.
//

import UIKit
import MessageKit

class DetailChatViewController: MessagesViewController {
    
    var senders = [SenderType]()
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageOutgoingAvatarSize(.zero)
        }
        
        senders.append(Sender(senderId: "self", displayName: "Me"))
        senders.append(Sender(senderId: "other", displayName: "He"))
        senders.append(Sender(senderId: "othe", displayName: "H"))
        
        messages.append(Message(sender: senders[0], messageId: "1", sentDate:Date.init(timeIntervalSince1970: -1412412), kind: .text("hello")))
        messages.append(Message(sender: senders[1], messageId: "2", sentDate:Date.init(timeIntervalSince1970: -141241), kind: .text("hello")))
        messages.append(Message(sender: senders[2], messageId: "3", sentDate:Date.init(timeIntervalSince1970: -14124), kind: .text("My name is")))
        messages.append(Message(sender: senders[1], messageId: "4", sentDate:Date.init(timeIntervalSince1970: -1412), kind: .text("My name isMy name isMy name isMy name isMy name isMy name isMy name isMy name isMy name isMy name is")))
        messages.append(Message(sender: senders[1], messageId: "5", sentDate:Date.init(timeIntervalSince1970: -141), kind: .text("My name")))
    }
}

extension DetailChatViewController : MessagesDataSource{
    func currentSender() -> SenderType {
        return senders[0]
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if (senders.count < 3){
            return nil
        }
        
        if isFromCurrentSender(message: message){
            return nil
        }
        
        let prevIndex = indexPath.section - 1
        if (prevIndex >= 0){
            if message.sender.senderId == messages[prevIndex].sender.senderId{
                return nil
            }
        }
        
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
}


extension DetailChatViewController : MessagesDisplayDelegate,MessagesLayoutDelegate{
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isFromCurrentSender(message: message){
            avatarView.isHidden = true
        }
        else
        {
            let nextIndex = indexPath.section + 1
            if (nextIndex < messages.count){
                if (messages[nextIndex].sender.senderId == message.sender.senderId){
                    avatarView.isHidden = true
                    if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
                        layout.setMessageIncomingAvatarSize(.zero)
                        return
                    }
                }
            }
            avatarView.image = UIImage(systemName: "plus")
        }
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (senders.count < 3){
            return 0
        }
        if isFromCurrentSender(message: message){
            return 0
        }
        let prevIndex = indexPath.section - 1
        if (prevIndex >= 0 ){
            if message.sender.senderId == messages[prevIndex].sender.senderId{
                return 0
            }
        }
        return 20
    }
}
