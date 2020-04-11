//
//  FirebaseChatService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 24.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseChatService: ConversationDataProviderProtocol {

    static let shared = FirebaseChatService(channelReference: db.collection("channels"))
    
    static var db = Firestore.firestore()
    var dataArray = [Channel]()
    var channelReference: CollectionReference
    
    init(channelReference: CollectionReference) {
        self.channelReference = channelReference
    }

    func syncConversationsData(reference: CollectionReference, completion: @escaping (_ dataArray: [Channel?]) -> Void) {
        var dataArray = [Channel?]()
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
                    print(newChannel)
                    dataArray.append(newChannel)
                } catch {
                    print("Error channel updating (\(error))")
                }
            }
            completion(dataArray)
        }
    }
    
    func addNewConversationsDocument(reference: CollectionReference, content: String) {

        let newChannel = Channel(identifier: String(Int.random(in: 1...1000)), name: content, lastMessage: "Create new channel", lastActivity: Date())
        reference.addDocument(data: newChannel.toDict)
    }

}

