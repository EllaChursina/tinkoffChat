//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import Firebase

protocol IServicesAssembly {
    var firebaseChatService: IFRBChatService { get }
    var firebaseMessageService: IFRBMessageService { get }
    var picturesService: IPicturesService { get }
    var scalingImageService: IScalingImageService { get }
    var channelSorter: IChannelsSorter { get }

}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var firebaseChatService: IFRBChatService  = FirebaseChatService()
    
    lazy var firebaseMessageService: IFRBMessageService  = FirebaseMessageService()
    
    lazy var picturesService: IPicturesService = PicturesService(requestSender: coreAssembly.requestSender)
    
    lazy var scalingImageService: IScalingImageService = ScalingImageService()
    
    lazy var channelSorter: IChannelsSorter = ChannelsSorter()
    
}
