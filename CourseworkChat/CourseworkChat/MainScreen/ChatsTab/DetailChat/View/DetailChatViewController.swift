//
//  ChatViewController.swift
//  CourseworkChat
//
//  Created by Admin on 15.05.2021.
//

import UIKit
import RxSwift
import MessageKit
import InputBarAccessoryView

class DetailChatViewController: MessagesViewController {
    
    var viewModel : DetailChatViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageOutgoingAvatarSize(.zero)
        }
        
        self.navigationItem.title = viewModel.output.title
        
        setupBackButton()
        setupMainBindings()
        setupGestureRecognizers()
    }
    
    
    private func setupBackButton(){
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("Chats", for: .normal)
        button.sizeToFit()
        
        button.rx
            .tap
            .bind(to: viewModel.input.back)
            .disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func setupMainBindings(){
        viewModel.output.reload
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else {return}
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            })
            
            .disposed(by: disposeBag)
        
        self.messageInputBar.sendButton.rx
            .tap
            .bind(to: viewModel.input.send)
            .disposed(by: disposeBag)
        
        self.messageInputBar.inputTextView.rx
            .text.orEmpty
            .bind(to: viewModel.input.messageText)
            .disposed(by: disposeBag)
    }
    
    private func setupGestureRecognizers(){
        let hideGesture = UITapGestureRecognizer()
        self.messagesCollectionView.addGestureRecognizer(hideGesture)

        hideGesture.rx.event.subscribe({[weak self] _ in
            guard let self = self else {return}
            self.messageInputBar.inputTextView.resignFirstResponder()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }).disposed(by: disposeBag)
    }
}



extension DetailChatViewController : MessagesDataSource{
    func currentSender() -> SenderType {
        return viewModel.output.curSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.output.chat.chatBody.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.output.chat.chatBody.messages.count
    }
    
    
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if (viewModel.output.chat.senders.count < 3){
            return nil
        }
        
        if isFromCurrentSender(message: message){
            return nil
        }
        
        let prevIndex = indexPath.section - 1
        if (prevIndex >= 0){
            if message.sender.senderId == viewModel.output.chat.chatBody.messages[prevIndex].sender.senderId{
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
            let messages = viewModel.output.chat.chatBody.messages
            if (nextIndex < messages.count){
                if (messages[nextIndex].sender.senderId == message.sender.senderId){
                    avatarView.isHidden = true
                    if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
                        layout.setMessageIncomingAvatarSize(.zero)
                        return
                    }
                    return
                }
            }
            
            avatarView.image = UIImage(systemName: "plus")
        }
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (viewModel.output.chat.senders.count < 3){
            return 0
        }
        if isFromCurrentSender(message: message){
            return 0
        }
        let prevIndex = indexPath.section - 1
        if (prevIndex >= 0 ){
            if message.sender.senderId == viewModel.output.chat.chatBody.messages[prevIndex].sender.senderId{
                return 0
            }
        }
        return 20
    }
}


extension DetailChatViewController : InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.text = ""
    }
}
