//
//  AddListItemViewController.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class AddListItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var business:Business!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    //back to prev view controller
    @IBAction func cancelButtonPressed(_ sender: AnyObject)
    {
        dismiss(animated: false, completion: nil)
    }
    
    //add new list item
    @IBAction func addButtonPressed(_ sender: AnyObject)
    {
        if let selectedRow = tableView.indexPathForSelectedRow?.row
        {
            //set arrays and write to user defaults
            User.sharedInstance.listElements[selectedRow].append(business.name!)
            User.sharedInstance.listNotes[selectedRow].append(String())
            User.sharedInstance.imageURL[selectedRow].append(business.imageURL!.absoluteString)
            User.sharedInstance.writeToFile()

            dismiss(animated: false, completion: nil)
        }
    }
    
    //TABLE DATASOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.sharedInstance.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddListCell", for: indexPath)
        
        cell.textLabel?.text = User.sharedInstance.listArray[indexPath.row]
        
        return cell
    }
}
