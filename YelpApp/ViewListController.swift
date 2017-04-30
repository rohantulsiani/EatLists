//
//  ViewListController.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Firebase

class ViewListController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var elementArray:[String]!
    var imageURLArray:[String]!
    var listIndex:Int!
    var listName:String!
    
    //back to prev view controller
    @IBAction func cancelButtonPressed(_ sender: AnyObject)
    {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any)
    {
        let numberOfElements = elementArray.count - 1
        let uid = UUID().uuidString
        
        let ref = FIRDatabase.database().reference().child(uid)
        var values = [String:String]()
        values["Name"] = listName
        
        for i in 0...numberOfElements
        {
            let businessName = elementArray[i]
            let imageURL = imageURLArray[i].replacingOccurrences(of: "ms.jpg", with: "348s.jpg")

            values[businessName] = imageURL
        }
        
        ref.updateChildValues(values)
        {
            (error, ref) in
            
            if(error != nil)
            {
                print(error!)
                return
            }
            
            //let url = "https://urls-53280.firebaseio.com/\(uid).json"
            let queryURL = "http://eatlists.site.swiftengine.net/?uid=\(uid)"
            
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = URL(string: queryURL)
            FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    //TABLE DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return elementArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewListCell", for: indexPath) as! ViewListCell
        
        cell.listName.text = elementArray[indexPath.row]
        let string = (User.sharedInstance.imageURL[listIndex][indexPath.row]).replacingOccurrences(of: "ms", with: "348s")
        let url = URL(string: string)!
        let data = try! Data(contentsOf: url)
        cell.imageViewer!.image = UIImage(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            (User.sharedInstance.listElements[listIndex]).remove(at: indexPath.row)
            (User.sharedInstance.imageURL[listIndex]).remove(at: indexPath.row)
            (User.sharedInstance.listNotes[listIndex]).remove(at: indexPath.row)
            elementArray.remove(at: indexPath.row)
            imageURLArray.remove(at: indexPath.row)
            User.sharedInstance.writeToFile()
            
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //basically used to set which list/element user selected in NoteViewController
        let navController = segue.destination as! UINavigationController
        let destController = navController.childViewControllers[0] as! NoteViewController
        
        let cell = sender as! UITableViewCell
        let cellIndex = tableView.indexPath(for: cell)?.row
        
        destController.listNum = self.listIndex
        destController.elementNum = cellIndex
    }
    
}
