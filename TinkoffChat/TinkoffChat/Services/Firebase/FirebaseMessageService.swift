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
    static let myName = "Someone"
    
    func messageReferenceFor(channelIdentifier: String?) -> CollectionReference {
        guard let channelIdentifier = channelIdentifier else { fatalError() }
        return FirebaseMessageService.db.collection("channels").document(channelIdentifier).collection("messages")
    }
    
    func syncConversationsData(reference: CollectionReference, completion: @escaping (_ dataArray: [Message]) -> Void){
        var dataArray = [Message]()
        reference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let messages = snapshot.documents
            dataArray.removeAll()
            for message in messages {
                do {
                    let newMessage = try Message(snapshotDocument: message)
                    guard let appendingMessage = newMessage else {
                        return
                    }
                    dataArray.append(appendingMessage)
                } catch {
                    print("Error channel updating (\(error))")
                }
            }
            dataArray = dataArray.sorted(by: {$0.created > $1.created})
            completion(dataArray)
        }
    }
    
    func addNewConversationsDocument(reference: CollectionReference, content: String) {
    
        let newMessage = Message(content: content, created: Date(), senderId: FirebaseMessageService.myID, senderName: FirebaseMessageService.myName)
        reference.addDocument(data: newMessage.toDict)
        
//        vc.newMessageTextField.text = ""
        
//        DispatchQueue.main.async {
//            vc.conversationTableView.reloadData()
//        }
    }
}

