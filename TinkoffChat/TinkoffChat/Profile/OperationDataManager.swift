//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 14.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

class OperationDataManager: DataManagerProtocol {
    
    let profileHandler = ProfileHandler()
    
    func saveProfile(profile: Profile, completion: @escaping (Bool) -> ()) {
        let operationQueue = OperationQueue()
        let saveOperation = SaveProfileOperation(profileHandler: profileHandler, profile: profile)
        saveOperation.qualityOfService = .userInitiated
        
        saveOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(saveOperation.successfulSave)
            }
        }
        
        operationQueue.addOperation(saveOperation)
    }
    
    func loadProfile(completion: @escaping (Profile?) -> ()) {
        
        let operationQueue = OperationQueue()
        let loadOperation = LoadProfileOperation(profileHandler: profileHandler)
        loadOperation.qualityOfService = .userInitiated
        
        loadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(loadOperation.profile)
            }
        }
        
        operationQueue.addOperation(loadOperation)
    }
}
