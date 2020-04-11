//
//  Channel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 19.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

class Channel {
    var identifier: String
    var name: String
    var lastMessage: String
    var lastActivity: Date
    var isActive: Bool
    
    init(identifier: String, name: String, lastMessage: String, lastActivity: Date) {
        var isChannelActive: Bool
        let timeInterval: TimeInterval = 600.0
        var timeInvervalLastActivity = lastActivity.timeIntervalSinceNow
        timeInvervalLastActivity.negate()
        if timeInvervalLastActivity <= timeInterval {
            isChannelActive = true} else {
            isChannelActive = false
        }
        
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.isActive = isChannelActive
    }
    
    init?(snapshotDocument: QueryDocumentSnapshot) {
        let identifier = snapshotDocument.documentID
        let data = snapshotDocument.data()
        
        var isChannelActive: Bool
        
        guard let name = data["name"] as? String,
            let lastMessage = data["lastMessage"] as? String,
            let stamp = data["lastActivity"] as? Timestamp
            else { return nil }
        
        let lastActivity = stamp.dateValue()
        let timeInterval: TimeInterval = 600.0
        var timeInvervalLastActivity = lastActivity.timeIntervalSinceNow
        timeInvervalLastActivity.negate()
        if timeInvervalLastActivity <= timeInterval {
            isChannelActive = true} else {
            isChannelActive = false
        }

        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.isActive = isChannelActive
    }
    
    
}

extension Channel {
        
    var toDict: [String: Any] {
        return ["identifier": identifier,
                "name": name,
                "lastMessage": lastMessage,
                "lastActivity": Timestamp(date: lastActivity )]
    }

}

