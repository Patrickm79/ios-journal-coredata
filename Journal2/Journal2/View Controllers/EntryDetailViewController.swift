//
//  EntryDetailViewController.swift
//  Journal2
//
//  Created by Patrick Millet on 12/17/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

 //MARK: Outlets
 @IBOutlet weak var titleTextField: UITextField!
 @IBOutlet weak var bodyTextView: UITextView!
 @IBOutlet weak var moodChange: UISegmentedControl!
 
 //MARK: Properties
 var entry: Entry? {
     didSet {
         updateViews()
     }
 }
 var entryController: EntryController?

 //MARK: Lifecycle
 override func viewDidLoad() {
     super.viewDidLoad()
     updateViews()
     bodyTextView.layer.cornerRadius = 8
     view.backgroundColor = .gray
 }
 
 //MARK: Actions

 @IBAction func saveTapped(_ sender: UIBarButtonItem) {
     guard let entryController = entryController,
         let title = titleTextField.text,
         let bodyText = bodyTextView.text
         else { return }
     let moodIndex = moodChange.selectedSegmentIndex
     let mood = Mood.allMoods[moodIndex]

     if let entry = entry {
        entry.title = title
        entry.mood = mood.rawValue
        entry.bodyText = bodyText
        entryController.sendEntryToServer(entry: entry)
     } else {
        let entry = Entry(title: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
        entryController.sendEntryToServer(entry: entry)
    }
     navigationController?.popViewController(animated: true)
 }

 
 //MARK: Methods
 
func updateViews() {
     guard isViewLoaded else { return }
     title = entry?.title ?? "Create Entry"
     titleTextField.text = entry?.title
     bodyTextView.text = entry?.bodyText
    
    
    if let mood = Mood(rawValue: entry?.mood ?? "😐"),
        let moodIndex = Mood.allMoods.firstIndex(of: mood) {
        moodChange.selectedSegmentIndex = moodIndex
        }
     }
 }
