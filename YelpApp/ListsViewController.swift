//
//  ListsViewController.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class ListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.sharedInstance.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        
        cell.listName.text = User.sharedInstance.listArray[indexPath.row]
        cell.imageViewer!.image = User.sharedInstance.listImageArray[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let navView = segue.destination as! UINavigationController
        
        //if want to add new list
        if let addView = navView.topViewController as? AddListViewController
        {
            addView.tableView = self.tableView
        }
        else if let viewListView = navView.topViewController as? ViewListController
        {
            //if want to view list elements
            if(tableView.indexPathForSelectedRow != nil)
            {
                viewListView.elementArray = User.sharedInstance.listElements[(tableView.indexPathForSelectedRow?.row)!]
                viewListView.imageURLArray = User.sharedInstance.imageURL[(tableView.indexPathForSelectedRow?.row)!]
                viewListView.listName = User.sharedInstance.listArray[(tableView.indexPathForSelectedRow?.row)!]
                let cell = (sender as! UITableViewCell)
                viewListView.listIndex = tableView.indexPath(for: cell)?.row
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        //if left swipe on element
        if editingStyle == .delete
        {
            //allow option to delete, if they do delete...
            //remove stuff from arrays
            User.sharedInstance.listElements.remove(at: indexPath.row)
            User.sharedInstance.listArray.remove(at: indexPath.row)
            User.sharedInstance.listImageArray.remove(at: indexPath.row)
            User.sharedInstance.listImageData.remove(at: indexPath.row)
            User.sharedInstance.listNotes.remove(at: indexPath.row)
            User.sharedInstance.imageURL.remove(at: indexPath.row)
            
            //write updated arrays to user default
            User.sharedInstance.writeToFile()
            
            //reload table data
            tableView.reloadData()
        }
    }
}
