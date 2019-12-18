//
//  Entry+Convenience.swift
//  Journal2
//
//  Created by Patrick Millet on 12/17/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//
import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case 😭
    case 😐
    case 🙂
    
    static var allMoods: [Mood] {
        return [.😭, .😐, .🙂]
    }
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
            let mood = mood,
            let timeStamp = timeStamp,
            let bodyText = bodyText else {
                return nil
        }
        return EntryRepresentation(title: title, mood: mood, identifier: identifier?.uuidString, timeStamp: timeStamp, bodyText: <#T##String#>)
    }

    convenience init(title: String,
                 bodyText: String,
                 mood: String,
                 timeStamp: Date = Date(),
                 identifier: UUID = UUID(),
                 context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    self.init(context: context)
    self.title = title
    self.bodyText = bodyText
    self.mood = mood
    self.timeStamp = timeStamp
    self.identifier = identifier    }
    
    convenience init?(taskRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation?.mood),
            let identifierString =
    }
}
