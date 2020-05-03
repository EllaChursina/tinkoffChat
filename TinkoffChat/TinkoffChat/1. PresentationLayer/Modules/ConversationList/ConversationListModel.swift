//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

protocol IConversationListModel: class {
    
    var frbService: IFRBChatService { get }
    
    var channelsSorter: IChannelsSorter { get }
    
}

class ConversationsListModel: IConversationListModel {
    
    var frbService: IFRBChatService
    
    var channelsSorter: IChannelsSorter
    
    init(frbService: IFRBChatService, channelsSorter: IChannelsSorter) {
        self.frbService = frbService
        self.channelsSorter = channelsSorter
    }
}
