//
//  FRBMessageService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

protocol IFRBMessageService: class {
    func syncConversationsData(reference: CollectionReference, completion: @escaping (_ dataArray: [Message]) -> Void)
    
    func addNewConversationsDocument(reference: CollectionReference, content: String)
    
    func messageReferenceFor(channelIdentifier: String?) -> CollectionReference
}

class FirebaseMessageService: IFRBMessageService{
    
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
                let newMessage = Message(snapshotDocument: message) 
                do {
                    let newMessage = try Message(snapshotDocument: message)
                    guard let appendingMessage = newMessage else {
                        continue
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
    
        let newMessage = Message(content: content, created: Date(), senderId: "420", senderName: "Someone")
        reference.addDocument(data: newMessage.toDict)
    }
        
}
