//
//  User.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class User: NSObject
{
    struct Static
    {
        static var token : Int = 0
        static var instance : User? = nil
    }
    
    private static var __once: () = {
            Static.instance = User()
    }()
    
    var listArray:[String]
    var imageURL:[[String]]
    var listElements:[[String]]
    var listNotes:[[String]]
    var listImageArray:[UIImage]
    var listImageData:[Data]
    
    let defaults = UserDefaults.standard
    
    override init()
    {
        //init values with default constructors
        listArray = [String]()
        listImageArray = [UIImage]()
        listElements = [[String]]()
        listNotes = [[String]]()
        listImageData = [Data]()
        imageURL = [[String]]()
        
   
        //if there is a list array saved in file, set listarray
        if defaults.object(forKey: "ListArray") != nil
        {
            listArray = defaults.object(forKey: "ListArray") as! [String]
        }
        
        //same for all the rest of these if statements
        if defaults.object(forKey: "ListImageData") != nil
        {
            listImageData = defaults.object(forKey: "ListImageData") as! [Data]
            
            for x in listImageData
            {
                listImageArray.append(UIImage(data: x)!)
            }
        }
        
        //same for all the rest of these if statements
        if defaults.object(forKey: "ListElements") != nil
        {
            listElements = defaults.object(forKey: "ListElements") as! [[String]]
        }
        
        if defaults.object(forKey: "imageURL") != nil
        {
            imageURL = defaults.object(forKey: "imageURL") as! [[String]]
        }
        
        //same for all the rest of these if statements
        if defaults.object(forKey: "ListNotes") != nil
        {
            listNotes = defaults.object(forKey: "ListNotes") as! [[String]]
        }
    }
    
    //singleton... only 1 User
    class var sharedInstance : User
    {
        _ = User.__once
        
        return Static.instance!
    }
    
    //write to user defaults
    func writeToFile()
    {
        defaults.set(listArray, forKey: "ListArray")
        defaults.set(listImageData, forKey: "ListImageData")
        defaults.set(listElements, forKey: "ListElements")
        defaults.set(listNotes, forKey: "ListNotes")
        defaults.set(imageURL, forKey: "imageURL")
    }
}
