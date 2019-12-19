//
//  CoreDataStack.swift
//  Journal2
//
//  Created by Patrick Millet on 12/17/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //MARK: Properties
    
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "Journal2")
        newContainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Failed to load persistent stores: \(error!)")
            }
        }
        return newContainer
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    //MARK: Methods
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
        } catch let saveError {
            error = saveError
            }
        }
        if let error = error { throw error }
    }
}
