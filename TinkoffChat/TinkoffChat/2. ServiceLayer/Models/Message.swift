//
//  Message.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 19.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

class Message {
    var content: String
    var created: Date
    var senderId: String
    var senderName: String
    
    init(content: String, created: Date, senderId: String, senderName: String) {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init?(snapshotDocument: QueryDocumentSnapshot) {
        let data = snapshotDocument.data()
        print(data)
        guard let content = data["content"] as? String,
            let senderId = data["senderID"] as? String,
            let senderName = data["senderName"] as? String,
            let stamp = data["created"] as? Timestamp
            else { return nil }
        let created = stamp.dateValue()
        
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
}

extension Message {
    
    var toDict: [String: Any?] {
        
        return ["content": content,
                "created": Timestamp(date: created),
                "senderID": senderId,
                "senderName": senderName]
    }
}
