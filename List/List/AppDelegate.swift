//
//  AppDelegate.swift
//  List
//
//  Created by Mary Paskhaver on 10/21/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Creates an SQL database named "DataModel"
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        
        // Set up storage. If something goes wrong, print an error.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
        
    // Save CoreData to NSPersistentContainer declared above
    func saveContext () {
        // Context: An area in which you can update your data. Data is saved to the container.
        let context = persistentContainer.viewContext
        
        // If we've modified existing data in any way (creating, updating, deleting, etc.), save the changes
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // If saving fails for some reason, print the error
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // Save CoreData when the user leaves the app running in the background
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext()
    }
    
    // Save CoreData when the user quits and totally closes the app
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

