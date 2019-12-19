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
        
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in}) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard error == nil else {
                print("Error fetching task \(error!)")
                completion(error)
                return
            }

            guard let data = data else {
                print("No data returned by data task")
                completion(NSError())
                return
            }

            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntry(with: entryRepresentations)
                completion(nil)
            } catch {
                print("Error decoding entry represnetations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }

    func sendEntryToServer(entry: Entry, completion: @escaping () -> Void = { }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard var representation = entry.entryRepresentation else {
                completion()
                return
            }
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            completion()
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error putting task to server: \(error!)")
                completion()
                return
            }

            completion()
        }.resume()
    }

    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }

        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                print(error!)
                completion(error)
                return
            }
            completion(error)
        }.resume()
    }



    private func updateEntry(with representations: [EntryRepresentation]) throws {
            let entriesWithID = representations.filter { $0.identifier != nil }
            let identifiersToFetch = entriesWithID.compactMap { UUID(uuidString: $0.identifier!) }
            let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, entriesWithID))
            var entriesToCreate = representationsByID

            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            let context = CoreDataStack.shared.container.newBackgroundContext()

            context.perform {
                do {
                    let existingEntries = try context.fetch(fetchRequest)
                    
                    for entry in existingEntries {
                        guard let id = entry.identifier,
                            let representation = representationsByID[id] else { continue }
                        self.update(entry: entry, with: representation)
                        entriesToCreate.removeValue(forKey: id)
                    }

                    for representation in entriesToCreate.values {
                        Entry(entryRepresentation: representation, context: context)
                    }
                } catch {
                    print("Error fetching entries for UUIDs: \(error)")
                }
            }
        try CoreDataStack.shared.save(context: context)
        }

    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
    }
}

