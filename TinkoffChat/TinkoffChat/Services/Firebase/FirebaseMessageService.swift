//
//  FirebaseMessageService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 24.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

class FirebaseMessageService: ConversationDataProviderProtocol {
    
    static let shared = FirebaseMessageService()
    static var db = Firestore.firestore()
    
    static let myID = "420"
    static let myName = "Ella Chursina"
    
    func messageReferenceFor(channelIdentifier: String?) -> CollectionReference {
        guard let channelIdentifier = channelIdentifier else { fatalError() }
        return FirebaseMessageService.db.collection("channels").document(channelIdentifier).collection("messages")
    }
    
    func syncConversationsData(reference: CollectionReference, viewController: UIViewController?, tableView: UITableView?){
        
        guard let vc = viewController as? ConversationViewController else {return}
        reference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let messages = snapshot.documents
            vc.dataArray.removeAll()
            
            for message in messages {
                let data = message.data()
                
                if let content = data["content"] as? String,
                    let senderId = data["senderID"] as? String,
                    let senderName = data["senderName"] as? String,
                    let stamp = data["created"] as? Timestamp {
                    let created = stamp.dateValue()
                    vc.dataArray.append(Message(content: content, created: created, senderId: senderId, senderName: senderName))
                } else {print("Error message data"); continue }
                
                vc.dataArray = vc.dataArray.sorted(by: {$0.created > $1.created})
            }
        }
        DispatchQueue.main.async {
            tableView?.reloadData()
        }
    }
    
    func addNewConversationsDocument(reference: CollectionReference, viewController: UIViewController?) {
        guard let vc = viewController as? ConversationViewController else {return}
        guard let content = vc.newMessageTextField.text else {print("No new messages")
            return}
        
        let newMessage = Message(content: content, created: Date(), senderId: FirebaseMessageService.myID, senderName: FirebaseMessageService.myName)
        reference.addDocument(data: newMessage.toDict)
        
        vc.newMessageTextField.text = ""
        
        DispatchQueue.main.async {
            vc.conversationTableView.reloadData()
        }
    }
}

