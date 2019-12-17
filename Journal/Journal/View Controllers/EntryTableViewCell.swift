//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Patrick Millet on 12/17/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryTimestamp: UILabel!
    @IBOutlet weak var entryDetail: UILabel!
    
        var entry: Entry? {
            didSet {
                updateViews()
            }
        }
    
    //MARK: Methods
    
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M/yy h:mm a"
            return formatter
        }

        private func updateViews() {
            guard let entry = entry,
                let timeStamp = entry.timeStamp else { return }
            let timeString = dateFormatter.string(from: timeStamp)
            entryTitle.text = entry.title
            entryDetail.text = entry.bodyText
            entryTimestamp.text = timeString
        }
    }
