//
//  TransactionProvider.swift
//  QRIS App
//
//  Created by Ariesta APP on 25/01/24.
//

import Foundation
import CoreData
public class TransactionProvider {
    public static let shared = TransactionProvider()
    private lazy var persistentContainer: NSPersistentContainer = {
        let name = "TransactionDataModel"
        let url = Bundle.module.url(forResource: name, withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOf: url!)
        let container = NSPersistentContainer(name: name, managedObjectModel: mom!)
        container.loadPersistentStores { _, err in
            guard err == nil else {
                fatalError("Unresolved Error: \(String(describing: err))")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        return container
    }()
    
    
    
    public func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
}
