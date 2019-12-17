//
//  EntryController.swift
//  Journal2
//
//  Created by Patrick Millet on 12/17/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    private func saveToPersistentStore() {
                let moc = CoreDataStack.shared.mainContext
                do {
                    try moc.save()
                } catch {
                    print("Error saving managed object context: \(error)")
                }
        }
        
        func create(title: String, bodyText: String, mood: String, timeStamp: Date,  identifier: String) {
            let _ = Entry(title: title, bodyText: bodyText, mood: mood, timeStamp: timeStamp, identifier: identifier)
            saveToPersistentStore()
        }

        func update(entry: Entry, title: String, bodyText: String, mood: String) {
            
            entry.title = title
            entry.bodyText = bodyText
            entry.mood = mood
            entry.timeStamp = Date()
            saveToPersistentStore()
        }

        func delete(for entry: Entry) {
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            saveToPersistentStore()
        }
}
