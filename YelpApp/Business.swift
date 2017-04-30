//
//  Business.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class Business: NSObject
{
    //business info
    let name: String?
    let id: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    
    //init business with dictionary read in from API
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as? String
        id = dictionary["id"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        
        if imageURLString != nil
        {
            imageURL = URL(string: imageURLString!)!
        }
        else
        {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        
        //piece together address via multiple dictionary values
        if location != nil
        {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0
            {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0
            {
                if !address.isEmpty
                {
                    address += ", "
                }
                
                address += neighborhoods![0] as! String
            }
        }
        
        self.address = address
        
        //join categories with comma, then store in string
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil
        {
            var categoryNames = [String]()
            
            for category in categoriesArray!
            {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            
            categories = categoryNames.joined(separator: ", ")
        }
        else
        {
            categories = nil
        }
        
        //get distance in meters
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil
        {
            //conversion to miles
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        }
        else
        {
            //only displays if user chooses to search from their current location
            distance = nil
        }
        
        //get url of rating image, to load in at a future date
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil
        {
            ratingImageURL = URL(string: ratingImageURLString!)
        }
        else
        {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    //converts to businesses array which is used elsewhere
    class func businesses(array: [NSDictionary]) -> [Business]
    {
        var businesses = [Business]()
        
        for dictionary in array
        {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        
        return businesses
    }
    
    class func business(_ business: NSDictionary) -> Business
    {
        return Business(dictionary: business)
    }
    
    
    //class functions to search using YelpClient class
    class func searchWithTerm(_ term: String, completion: @escaping ([Business]?, NSError?) -> Void)
    {
        _ = YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, NSError?) -> Void) -> Void
    {
        _ = YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    
    class func searchWithTerm(_ term: String, location: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, NSError?) -> Void) -> Void
    {
        _ = YelpClient.sharedInstance.searchWithTerm(term, location: location, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    
    class func searchWithTerm(_ term: String, lat:Double, long:Double, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, NSError?) -> Void) -> Void
    {
        _ = YelpClient.sharedInstance.searchWithTerm(term, lat:lat, long:long, sort: sort, categories: categories, deals: deals, completion: completion)
    }
}
