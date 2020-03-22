//
//  ConversationService.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 22.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

protocol ConversationService {
    static var db: Firestore? { get set }
    static var reference: CollectionReference? { get set }
}
