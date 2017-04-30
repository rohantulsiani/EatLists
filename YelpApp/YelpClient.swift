//
//  YelpClient.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager

//KEYS PROVIDED BY YELP FOR INITIALIZATION
let yelpConsumerKey = "RrErpTEv1aWRSaFCz189Rw"
let yelpConsumerSecret = "X94M9lk-znjcYWSTjCvLAJd7-94"
let yelpToken = "dYMFgUPLzhnwlqo6jHpkaE0mNeNriNC8"
let yelpTokenSecret = "U-VP9jhCrZP__Cf64jVAQs5bBUQ"

//ENUM FOR SORTING
enum YelpSortMode: Int
{
    case bestMatched = 0, distance, highestRated
}

class YelpClient: BDBOAuth1RequestOperationManager
{
    struct Static
    {
        static var token : Int = 0
        static var instance : YelpClient? = nil
    }
    
    private static var __once: () = {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    }()
    
    var accessToken: String!
    var accessSecret: String!
    
    //Singleton
    class var sharedInstance : YelpClient
    {
        _ = YelpClient.__once
        
        return Static.instance!
    }
    
    //need because of YELP API conforming to BDBOAuth1RequestOperationManager
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //initialize with provided keyes
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!)
    {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, NSError?) -> Void) -> AFHTTPRequestOperation
    {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    //search via GET REQUEST
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, NSError?) -> Void) -> AFHTTPRequestOperation
    {
        // Default the Location to LA
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "location": "Los Angeles, CA" as AnyObject]
        
        if sort != nil
        {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0
        {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil
        {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        
        //print(parameters)
        
        //GET REQUEST RETURNS JSON, WHICH I STORED IN DICTIONARY
        return self.get("search", parameters: parameters, success:
            {
                (operation: AFHTTPRequestOperation?, response: Any?) -> Void in
                let object = response as AnyObject?
                
                let dictionaries = object?["businesses"] as? [NSDictionary]
                
                if dictionaries != nil
                {
                    completion(Business.businesses(array: dictionaries!), nil)
                }
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
                completion(nil, error as NSError?)
        })!
    }
    
    //WITH LOCATION PARAMETER
    func searchWithTerm(_ term: String, location: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, NSError?) -> Void) -> AFHTTPRequestOperation
    {
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "location": location as AnyObject]
        
        if sort != nil
        {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0
        {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil
        {
            parameters["deals_filter"] = deals! as AnyObject?
        }
                
        return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation?, response: Any?) -> Void in
            let object = response as AnyObject?
            let dictionaries = object?["businesses"] as? [NSDictionary]
            if dictionaries != nil
            {
                completion(Business.businesses(array: dictionaries!), nil)
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
                completion(nil, error as NSError?)
        })!
    }
    
    //WITH LONG LAT
    func searchWithTerm(_ term: String, lat:Double, long:Double, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, NSError?) -> Void) -> AFHTTPRequestOperation {
        // Default the location to San Francisco
        
        let locString = "\(lat),\(long)"
    
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": locString as AnyObject]
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue as AnyObject?
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as AnyObject?
        }
        

        return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation?, response: Any?) -> Void in
            let object = response as AnyObject?
            let dictionaries = object?["businesses"] as? [NSDictionary]
            if dictionaries != nil
            {
                completion(Business.businesses(array: dictionaries!), nil)
            }
        }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
            completion(nil, error as NSError?)
        })!
    }

}
