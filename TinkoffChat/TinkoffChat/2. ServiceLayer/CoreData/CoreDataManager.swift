//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 12.04.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ICoreDataManager: class {
    func loadAppUser(completion: @escaping (IAppUser?) -> ())
    func saveAppUser(_ profile: IAppUser, completion: @escaping (Bool) -> ())

}

class CoreDataManager: ICoreDataManager {
    private let stack: CoreDataStack
    
    init() {
        stack = CoreDataStack()
    }
    
    func saveAppUser(_ profile: IAppUser, completion: @escaping (Bool) -> ()) {
        let appUser: AppUser? = findOrInsert(in: stack.saveContext)
        appUser?.username = profile.username
        appUser?.usersDescription = profile.usersDescription
        
        if let avatar = profile.avatar {
            appUser?.avatar = avatar.jpegData(compressionQuality: 1.0)
        }
        
        stack.performSave(context: stack.saveContext) { error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func loadAppUser(completion: @escaping (IAppUser?) -> ()) {
        guard let appUser: AppUser = findOrInsert(in: stack.saveContext) else {
            completion(nil)
            return
        }
        
        let profile = Profile()
        profile.username = appUser.username
        profile.usersDescription = appUser.usersDescription
        if let avatar = appUser.avatar {
            profile.avatar = UIImage(data: avatar)
        }
        
        completion(profile)
    }
    
    private func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let requestTemplateName = "AppUserFetchRequest"
        guard let fetchRequest = model.fetchRequestTemplate(forName: requestTemplateName) as? NSFetchRequest<AppUser> else {
            assert(false, "Error: no template with name \(requestTemplateName)")
            return nil
        }
        
        return fetchRequest
    }
    
    private func findOrInsert(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context")
            assert(false)
            return nil
        }
        
        var profile: AppUser?
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
            profile = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser
        }
        
        return profile
    }
}

