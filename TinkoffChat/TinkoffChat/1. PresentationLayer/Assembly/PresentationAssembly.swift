//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 11.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
    
    func profileViewController() -> ProfileViewController
    
    func conversationsListViewController() -> ConversationListViewController
    
    func conversationViewController(model: ConversationModel) -> ConversationViewController
    
    func newChannelViewController(model: NewChannelModel) -> NewChannelViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController(model: profileModel())
    }
    
    
    private func profileModel() -> IAppUserModel {
        return ProfileModel(dataService: CoreDataManager())
    }
    
    func conversationsListViewController() -> ConversationListViewController {
        guard let vc = UIStoryboard(name: "ConversationList", bundle: nil).instantiateInitialViewController() as? ConversationListViewController else { fatalError() }
        let model = conversationsListModel()
        vc.model = model
        return vc
    }
    
    private func conversationsListModel() -> IConversationListModel {
        return ConversationsListModel(frbService: serviceAssembly.firebaseChatService)
    }
    
    func conversationViewController(model: ConversationModel) -> ConversationViewController {
        return ConversationViewController(model: model)
    }
    
    func newChannelViewController(model: NewChannelModel) -> NewChannelViewController {
        return NewChannelViewController(model: model)
    }
    
}
