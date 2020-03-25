//
//  Profile.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 13.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

class Profile {
    var username: String?
    var usersDescription: String?
    var avatar: UIImage?
    
    var usernameChanged = false
    var usersDescriptionChanged = false
    var imageChanged = false
    
    init() {}
    
    init(username: String?, usersDescription: String?, avatar: UIImage?) {
        self.username = username
        self.usersDescription = usersDescription
        self.avatar = avatar
    }
}


