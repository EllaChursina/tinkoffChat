//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol IConversationModel: class {
    
    var frbService: IFRBMessageService { get }
    
}

class ConversationModel: IConversationModel {
    
    var frbService: IFRBMessageService
    
    init(frbService: IFRBMessageService) {
        self.frbService = frbService
    }
    
}
