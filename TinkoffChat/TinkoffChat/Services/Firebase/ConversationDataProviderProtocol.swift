//
//  ConversationDataProviderProtocol.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 25.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

protocol ConversationDataProviderProtocol {
    
    associatedtype DataModel
    
    func syncConversationsData(reference: CollectionReference, completion: @escaping (_ dataArray: [DataModel]) -> Void)
    
    func addNewConversationsDocument(reference: CollectionReference, content: String)
}
