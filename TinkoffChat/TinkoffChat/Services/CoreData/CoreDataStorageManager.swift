//
//  CoreDataStorageManager.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStorageManager: DataManagerProtocol {
    private let coreDataStack = CoreDataStack()
    
    func saveProfile(_ profile: Profile, completion: @escaping (Error?) -> ()) {
        let saveContext = coreDataStack.saveContext
        
        saveContext.perform {
            let profileEntity = ProfileEntity.findOrInsert(in: saveContext)
            profileEntity?.username = profile.username
            profileEntity?.usersDescription = profile.usersDescription
            
            if let avatar = profile.avatar {
                profileEntity?.avatar = avatar.jpegData(compressionQuality: 1.0)
            }
            
            self.coreDataStack.performSave(context: saveContext) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            
        }
    }
    
    func loadProfile(completion: @escaping (Profile?, Error?) -> ()) {
        let mainContext = coreDataStack.mainContext
        
        mainContext.perform {
            guard let profileEntity = ProfileEntity.findOrInsert(in: mainContext) else {
                completion(nil, nil)
                return
            }
            
            let profile = Profile()
            profile.username = profileEntity.username
            profile.usersDescription = profileEntity.usersDescription
            if let avatar = profileEntity.avatar {
                profile.avatar = UIImage(data: avatar)
            }
            
            completion(profile, nil)
        }
    }
}

extension ProfileEntity {
    class func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<ProfileEntity>? {
        let requestTemplateName = "ProfileFetchRequest"
        guard let fetchRequest = model.fetchRequestTemplate(forName: requestTemplateName) as? NSFetchRequest<ProfileEntity> else {
            assert(false, "Error: no template with name \(requestTemplateName)")
            return nil
        }
        
        return fetchRequest
    }
    
    class func insert(in context: NSManagedObjectContext) -> ProfileEntity? {
        return NSEntityDescription.insertNewObject(forEntityName: "ProfileEntity", into: context) as? ProfileEntity
    }
    
    class func findOrInsert(in context: NSManagedObjectContext) -> ProfileEntity? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context")
            assert(false)
            return nil
        }
        
        var profile: ProfileEntity?
        guard let fetchRequest = fetchRequest(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple profiles found")
            if let foundProfile = results.first {
                profile = foundProfile
            }
        }
        catch {
            print("Failed to fetch profile \(error)")
        }
        
        if profile == nil {
            profile = ProfileEntity.insert(in: context)
        }
        
        return profile
    }
}
