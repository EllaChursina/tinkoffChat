//
//  FRBChatService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

protocol IFRBChatService: class {
    func syncConversationsData(reference: CollectionReference, completion: @escaping (_ dataArray: [Channel]) -> Void)
    
    func addNewConversationsDocument(reference: CollectionReference, content: String)
    
    func getChannelReference() -> CollectionReference
}

class FirebaseChatService: IFRBChatService {

    static var db = Firestore.firestore()
    var dataArray = [Channel]()
    
    func getChannelReference() -> CollectionReference {
        let reference = FirebaseChatService.db.collection("channels")
        return reference
    }
    
    func syncConversationsData(reference: CollectionReference, completion: @escaping (_ dataArray: [Channel]) -> Void) {
        var dataArray = [Channel]()
        reference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
            print("Error fetching document: \(error!)")
            return
            }
            dataArray.removeAll()
            let channels = snapshot.documents
            
            for channel in channels {
                do {
                    let newChannel =  try Channel(snapshotDocument: channel)
                    guard let appendingChannel = newChannel else {
                        continue
                    }
                    print(newChannel)
                    dataArray.append(appendingChannel)
                } catch {
                    print("Error channel updating (\(error))")
                }
            }
            dataArray = dataArray.sorted(by: {$0.lastMessage < $1.lastMessage})
            completion(dataArray)
        }
    }
    
    func addNewConversationsDocument(reference: CollectionReference, content: String) {

        let newChannel = Channel(identifier: String(Int.random(in: 1...1000)), name: content, lastMessage: "Create new channel", lastActivity: Date())
        reference.addDocument(data: newChannel.toDict)
    }

}
