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
    
    func syncConversationsData(reference: CollectionReference, viewController: UIViewController?, tableView: UITableView?)
    
    func addNewConversationsDocument(reference: CollectionReference, viewController: UIViewController?)
}
