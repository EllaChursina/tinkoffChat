//
//  ProfileOperations.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 14.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

class SaveProfileOperation: Operation {
    
    var successfulSave = true
    private let profileHandler: ProfileHandler
    private let profile: Profile
    
    init(profileHandler: ProfileHandler, profile: Profile) {
        self.profileHandler = profileHandler
        self.profile = profile
        super.init()
    }
    
    override func main() {
        if isCancelled { return }
        successfulSave = profileHandler.saveData(profile: profile)
    }
}

class LoadProfileOperation: Operation {
    
    private let profileHandler: ProfileHandler
    var profile: Profile?
    
    init(profileHandler: ProfileHandler) {
        self.profileHandler = profileHandler
        super.init()
    }
    
    override func main() {
        if isCancelled {return}
        profile = profileHandler.loadData()
    }
}
