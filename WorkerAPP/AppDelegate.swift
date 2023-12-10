//
//  AppDelegate.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 08/10/2023.
//

import UIKit
import FirebaseCore
import CoreData
import Resolver
import Domain
import DataSource
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        
        registRepo()
        registUseCase()
        
        return true
    }

    private func registRepo() {
        Resolver.register { AccountDataSourceImpl() as CreateAccountRepo }
        Resolver.register { UploadFileDataSourceImpl() as UpLoadFileRepo }
        Resolver.register { DataBaseDataSourceImpl() as DataBaseRepo }
        Resolver.register { DegreeDataSourceImpl() as DegreeRepo }
        Resolver.register { JobDataSourceImpl() as JobRepo }
        Resolver.register { OrderRemoteDataSourceImpl() as OrderRepo }
        Resolver.register { CardRemoteDataSourceImpl() as CardRepo }
    }
    private func registUseCase() {
        Resolver.register { AccountUseCase() as IAccountUseCase }
        Resolver.register { UploadFileUseCase() as IUploadFileUseCase }
        Resolver.register { DataBaseUseCase() as IDataBaseUseCase }
        Resolver.register { AddressUseCase() as IAddressUseCase }
        Resolver.register { DegreeUseCase() as IDegreeUseCase }
        Resolver.register { OrderUseCase() as IOrderUseCase }
        Resolver.register { CardUseCase() as ICardUseCase}
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "WorkerAPP")
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

