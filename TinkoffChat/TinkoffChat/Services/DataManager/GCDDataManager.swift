//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 13.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

class GCDDataManager: DataManagerProtocol {
    
    let profileHandler = ProfileHandler()
    
    func saveProfile(profile: Profile, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let saveSucceeded = self.profileHandler.saveData(profile: profile)
            
            DispatchQueue.main.async {
                completion(saveSucceeded)
            }
        }
    }
    
    func loadProfile(completion: @escaping (Profile?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let restoredProfile = self.profileHandler.loadData()
            
            DispatchQueue.main.async {
                completion(restoredProfile)
            }
        }
    }
}
