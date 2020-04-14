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
    
    func conversationViewController() -> ConversationViewController
    
    func newChannelViewController() -> NewChannelViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func profileViewController() -> ProfileViewController {
        guard let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as? ProfileViewController else { fatalError() }
        let model = profileModel()
        vc.model = model
        return vc
    }
    
    
    private func profileModel() -> IAppUserModel {
        return ProfileModel(dataService: CoreDataManager())
    }
    
    func conversationsListViewController() -> ConversationListViewController {
        guard let vc = UIStoryboard(name: "ConversationList", bundle: nil).instantiateInitialViewController() as? ConversationListViewController else { fatalError() }
        let model = conversationsListModel()
        
        let presentationAssembly: IPresentationAssembly = self
        vc.model = model
        vc.presentationAssembly = presentationAssembly
        return vc
    }
    
    private func conversationsListModel() -> IConversationListModel {
        return ConversationsListModel(frbService: serviceAssembly.firebaseChatService)
    }
    
    func conversationViewController() -> ConversationViewController {
        guard let vc = UIStoryboard(name: "Conversation", bundle: nil).instantiateInitialViewController() as? ConversationViewController else { fatalError() }
        let model = conversationModel()
        vc.model = model
        return vc
    }
    
    private func conversationModel() -> IConversationModel {
        return ConversationModel(frbService: serviceAssembly.firebaseMessageService)
    }
    
    func newChannelViewController() -> NewChannelViewController {
        guard let vc = UIStoryboard(name: "NewChannel", bundle: nil).instantiateInitialViewController() as? NewChannelViewController else { fatalError() }
        let model = newChannelModel()
        vc.model = model
        return vc
    }
    
    private func newChannelModel() -> INewChannelModel {
        return NewChannelModel(frbService: serviceAssembly.firebaseChatService)
    }
    
}
