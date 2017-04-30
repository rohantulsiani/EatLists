//
//  FilterViewController.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 4/17/17.
//  Copyright © 2017 Rohan Tulsiani. All rights reserved.
//

import UIKit

@objc protocol ImageFilterViewControllerDelegate
{
   @objc optional func imageFilterViewController(_ filtersViewController:ImageFilterViewController, didUpdateFilters filters:[String])}

class ImageFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    weak var delegate:ImageFilterViewControllerDelegate? 
    var filters: [String]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        filters = ["Sepia"]
    }

    @IBAction func cancelButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any)
    {
        let rowsSelected = tableView.indexPathsForSelectedRows
        var arrayToSend : [String] = []
        
        for i in rowsSelected!
        {
           arrayToSend.append(filters[i.row])
        }
        
        delegate?.imageFilterViewController?(self, didUpdateFilters: arrayToSend)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // get all filters
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        //set cells business = value of business array at that row. setting values handled by delegate
        cell.textLabel?.text = filters[indexPath.row]
        return cell
    }
}
