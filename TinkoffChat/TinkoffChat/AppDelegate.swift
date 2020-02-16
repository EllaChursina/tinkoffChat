//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 13.02.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Logger.log(tag: .AppDelegate, message: "Application moved from <not running> to <inactive>: \(#function)")
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Logger.log(tag: .AppDelegate, message: "Application in the <inactive> state: \(#function)")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.log(tag: .AppDelegate, message: "Application moved from <active> to <inactive>:  \(#function)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.log(tag: .AppDelegate, message: "Application moved from <inactive> to <active>: \(#function)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.log(tag: .AppDelegate, message: "Application moved from <inactive> to <background>:  \(#function)")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.log(tag: .AppDelegate, message: "Application moved from <background> to <inactive>:  \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.log(tag: .AppDelegate, message: "Application moved from <background> to <not running>:  \(#function)")
        
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TinkoffChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

