//
//  ChatViewController.swift
//  ChatWonder
//
//  Created by Mac on 30.06.2022.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {

    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Murat")
    private let secondSender = Sender(photoURL: "", senderId: "2", displayName: "Alp")
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Nasılsın")))
        messages.append(Message(sender: secondSender, messageId: "1", sentDate: Date(), kind: .text("İyiyim teşekkür ederim sen nasılsın?")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        
    }
    
}
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ? UIColor(red: 75/255, green: 210/255, blue: 249/255, alpha: 1) : UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        }
  
    
}
