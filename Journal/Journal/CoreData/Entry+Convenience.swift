//
//  Entry+Convenience.swift
//  Journal
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

    convenience init(title: String,
                 bodyText: String,
                 mood: String,
                 timeStamp: Date = Date(),
                 identifier: String,
                 context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    self.init(context: context)
    self.title = title
    self.bodyText = bodyText
    self.mood = mood
    self.timeStamp = timeStamp
    self.identifier = identifier    }
}
