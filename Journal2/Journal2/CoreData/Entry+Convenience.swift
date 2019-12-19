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
            guard let bodyText = bodyText,
                let title = title,
                let mood = mood else {
                    return nil
            }
        return EntryRepresentation(title: title, mood: mood, identifier: identifier?.uuidString ?? UUID().uuidString, timeStamp: timeStamp!, bodyText: bodyText)
    }

        convenience init(title: String, bodyText: String? = nil, timeStamp: Date = Date.init(timeIntervalSinceNow: 0), identifier: UUID = UUID(), mood: Mood, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

            self.init(context: context)

            self.title = title
            self.bodyText = bodyText
            self.timeStamp = timeStamp
            self.identifier = identifier
            self.mood = mood.rawValue
        }

        @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            guard let mood = Mood(rawValue: entryRepresentation.mood),
                let identifierString = entryRepresentation.identifier,
                let identifier = UUID(uuidString: identifierString) else {
                    return nil
            }

            self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText,
                      identifier: identifier,
                      mood: mood,
                      context: context)
        }
   }
