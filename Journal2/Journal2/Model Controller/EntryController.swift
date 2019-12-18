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

    let baseURL = URL(string: "https://journal-project-fde17.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    private func saveToPersistentStore() {
                let moc = CoreDataStack.shared.mainContext
                do {
                    try moc.save()
                } catch {
                    print("Error saving managed object context: \(error)")
                }
        }
    
    init() {
        fetchTasksFromServer()
    }
        
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching entries: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned by data task.")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do{
                let entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntry(with: entryRepresentations)
            } catch {
                
            }
        }
        
    }
    
    func updateEntry(with representations: [EntryRepresentation]) throws {
        let entryWithID = representations.filter { $0.identifier != nil }
        let identifiersToFetch = entryWithID.compactMap { UUID(uuidString: $0.identifier!) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entryWithID))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
        do {
            let existingEntries = try context.fetch(fetchRequest)
            
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            
            for representation in entriesToCreate.values {
                Entry(
            }
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

extension String {
    
}
