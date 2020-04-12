//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 27.03.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var storeURL: URL {
        get {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsURL.appendingPathComponent("TinkoffChat.sqlite")
            
            return url
        }
    }
    
    private let managedObjectModelName = "TinkoffChat"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        var modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd")!
        let versionInfoURL = modelURL.appendingPathComponent("VersionInfo.plist")
        if let versionInfoNSDictionary = NSDictionary(contentsOf: versionInfoURL),
            let version = versionInfoNSDictionary.object(forKey: "NSManagedObjectModel_CurrentVersionName") as? String {
            modelURL.appendPathComponent("\(version).mom")
            return NSManagedObjectModel(contentsOf: modelURL)!
        }
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeURL,
                                               options: options)
        }
        catch {
            print("Error adding persistent store to coordinator: \(error)")
        }
        
        return coordinator
    }()
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        
        return mainContext
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        
        return saveContext
    }()
    
    func performSave(context: NSManagedObjectContext, completion: @escaping (Error?) -> ()) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                    completion(error)
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completion: completion)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
}
