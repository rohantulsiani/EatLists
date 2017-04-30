//
//  NoteViewController.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/9/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController
{
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var listNum:Int!
    var elementNum:Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let text = User.sharedInstance.listNotes[listNum][elementNum]
        self.automaticallyAdjustsScrollViewInsets = false
        textView.text = text
    }
    
    //if save, then store new stuff in user defaults
    @IBAction func saveButtonPressed(_ sender: AnyObject)
    {
        User.sharedInstance.listNotes[listNum][elementNum] = textView.text
        User.sharedInstance.writeToFile()
        dismiss(animated: false, completion: nil)
        textView.resignFirstResponder()
    }
    
    @IBAction func editButtonPressed(_ sender: AnyObject)
    {
        //toggle between edit and done
        if self.editButton.title == "Edit"
        {
            self.editButton.title = "Done"
            textView.isEditable = true
            textView.isSelectable = true
        }
        else
        {
            self.editButton.title = "Edit"
            textView.isEditable = false
            textView.isSelectable = false
            textView.resignFirstResponder()
        }
    }
    
}
