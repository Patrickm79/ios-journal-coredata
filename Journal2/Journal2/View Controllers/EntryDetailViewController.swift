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
         let body = bodyTextView.text
         else { return }
     let moodIndex = moodChange.selectedSegmentIndex
     let mood = Mood.allMoods[moodIndex]

     if let entry = entry {
         entryController.update(entry: entry, title: title, bodyText: body, mood: mood.rawValue)
     } else {
         entryController.create(title: title, bodyText: body, mood: mood.rawValue, timeStamp: Date(), identifier: "")
     }
     navigationController?.popViewController(animated: true)
 }

 
 //MARK: Methods
 
func updateViews() {
     guard isViewLoaded else { return }
     title = entry?.title ?? "Create Entry"
     titleTextField.text = entry?.title

     let mood: Mood
     if let entryMood = entry?.mood,
         let moods = Mood(rawValue: entryMood){
         mood = moods
     } else {
         mood = .😐
     }

     let moodIndex = Mood.allMoods.firstIndex(of: mood)!
     moodChange.selectedSegmentIndex = moodIndex
     bodyTextView.text = entry?.bodyText
     }
 }
