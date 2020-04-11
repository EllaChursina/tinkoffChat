//
//  Channel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 19.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String
    let lastActivity: Date
    
    func update(with json)
}

extension Channel {
    var toDict: [String: Any] {
        return ["identifier": identifier,
                "name": name,
                "lastMessage": lastMessage,
                "lastActivity": Timestamp(date: lastActivity)]
    }
}

