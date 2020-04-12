//
//  NewChannelModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol INewChannelModel: class {
    
    var frbService: IFRBChatService { get }
    
}

class NewChannelModel: IConversationListModel {
    
    var frbService: IFRBChatService
    
    init(frbService: IFRBChatService) {
        self.frbService = frbService
    }
    
}
