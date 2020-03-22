//
//  ConversationCellModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}

