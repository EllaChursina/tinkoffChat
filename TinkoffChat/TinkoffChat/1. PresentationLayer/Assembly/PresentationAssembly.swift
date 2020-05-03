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
    
    func picturesViewController() -> PicturesViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func profileViewController() -> ProfileViewController {
        guard let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as? ProfileViewController else { fatalError() }
        let model = profileModel()
        let presentationAssembly: IPresentationAssembly = self
        vc.model = model
        vc.presentationAssembly = presentationAssembly
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
        return ConversationsListModel(frbService: serviceAssembly.firebaseChatService, channelsSorter: serviceAssembly.channelSorter)
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
    
    func picturesViewController() -> PicturesViewController {
        guard let vc = UIStoryboard(name: "Pictures", bundle: nil).instantiateInitialViewController() as? PicturesViewController else { fatalError() }
        let model = picturesModel()
        vc.model = model
        return vc
    }
    
    private func picturesModel() -> IPicturesModel {
        return PicturesModel(picturesService: serviceAssembly.picturesService, scaleImageService: serviceAssembly.scalingImageService)
    }
    
    
    
}
