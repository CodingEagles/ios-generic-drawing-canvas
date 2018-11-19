//
//  CoreDataManager.swift
//  ios-generic-drawing-canvas
//
//  Created by Lucas Tavares on 19/11/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//
import UIKit
import CoreData

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DrawCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() -> Bool {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as Error
                print(nserror)
                return false
            }
        }
        return true
    }
    
    
    func fetch<T>(_ request: NSFetchRequest<T>) -> [T]? {
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            print(error)
            return [T]()
        }
    }
    
    func delete<T:NSManagedObject>(object:T) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        managedContext.delete(object)
        saveContext()
    }
}
