//
//  ProfileHandler.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 25.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit

class ProfileHandler {
    private let usernameFile = "username.txt"
    private let usersDescriptionFile = "usersDescription.txt"
    private let avatarFile = "avatarImage.png"
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func saveData(profile: Profile) -> Bool {
        do {
            if profile.usernameChanged, let username = profile.username {
                try username.write(to: filePath.appendingPathComponent(usernameFile), atomically: true, encoding: String.Encoding.utf8)
            }
            
            if profile.usersDescriptionChanged, let usersDescription = profile.usersDescription {
                try usersDescription.write(to: filePath.appendingPathComponent(usersDescriptionFile), atomically: true, encoding: String.Encoding.utf8)
            }
            
            if profile.imageChanged, let avatar = profile.avatar {
                let avatarData = avatar.pngData()
                try avatarData?.write(to: filePath.appendingPathComponent(avatarFile), options: .atomic)
            }
            return true
        } catch {
            return false
        }
    }
    
    func loadData() -> Profile? {
        let profile = Profile()
        do {
            profile.username = try String(contentsOf: filePath.appendingPathComponent(usernameFile))
            profile.usersDescription = try String(contentsOf: filePath.appendingPathComponent(usersDescriptionFile))
            profile.avatar = UIImage(contentsOfFile: filePath.appendingPathComponent(avatarFile).path)
            return profile
        } catch {
            return nil
        }
    }
}
