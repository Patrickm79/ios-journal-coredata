//
//  EntryRepresentation.swift
//  Journal2
//
//  Created by Patrick Millet on 12/18/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var mood: String
    var identifier: String?
    var timeStamp: Date
    var bodyText: String?
}
