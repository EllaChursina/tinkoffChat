//
//  MessageDataModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 28.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

class MessageDataModel {
    var messagesData = [MessageCellModel]()
    
    init() {
        setupData()
    }
    // Some random chat foe conversation cell
    func setupData() {
    let messages = ["Hello. How are things today?",
                    "I,m doing well, how about you",
                    "Pretty good, just listening to some music right not before finding something to do",
                    "What kind of music do you like?",
                    "I love abstract hip-hop. i,ve met Shilo from Krovostok before too, you?",
                    "I have never met Shilo",
                    "He,s nice, it was at a concert",
                    "Harry Potter and the Methods of Rationality, do you?",
                    "Okay, waht do you do then?",
                    "I'm a stay home and cry about my life "
        ]
        for i in 0..<messages.count {
        let message = MessageCellModel(text: messages[i])
        messagesData.append(message)
    }
    }
}

