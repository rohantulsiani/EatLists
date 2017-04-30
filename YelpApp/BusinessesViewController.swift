//
//  BusinessViewController.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, CLLocationManagerDelegate
{
    var businesses: [Business]!
    let locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D!
    var hasBeenDone = false
    
    var userInstance:User!
    
    @IBOutlet weak var tableView: UITableView!
    
    //if add button is pressed segue to view to add element to list
    @IBAction func addButtonPressed(_ sender: AnyObject)
    {
        if(tableView.indexPathForSelectedRow != nil)
        {
            self.performSegue(withIdentifier: "newView", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if(FBSDKAccessToken.current() == nil)
        {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            return
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        userInstance = User.sharedInstance //get shared instance of user

        //formatting fix
        self.automaticallyAdjustsScrollViewInsets = false;

        //set tables delegate/datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        //setup tableview
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //setup location manager
        locationManager.distanceFilter = 100.0; // Will notify the LocationManager every 100 meters
        locationManager.requestAlwaysAuthorization()
        
        //if they enabled location services
        if CLLocationManager.locationServicesEnabled()
        {
            //set delegate
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            //start core location
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locValue = manager.location!.coordinate //store coordinates

        if(!hasBeenDone)
        {
            //search with user's current location
            Business.searchWithTerm("", lat: self.locValue.latitude, long: self.locValue.longitude, sort: nil, categories: nil, deals: nil, completion: { (businesses: [Business]?, error: NSError?) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            })
            
            hasBeenDone = true //only happen once
        }
    }
    //Table View Stuff
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //if search returns businesses then # of rows = # of business
        if businesses != nil
        {
            return businesses!.count
        }
        else
        {
            return 0 //otherwise # of rows = 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        //set cells business = value of business array at that row. setting values handled by delegate
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let _ = segue.destination as? FBLoginVC
        {
            return
        }
        
        let navigationController = segue.destination as! UINavigationController //get parent nav controller
        
        //if segue to filters
        if let filtersViewController = navigationController.topViewController as? FiltersViewController
        {
            //set filters delegate to this class
            filtersViewController.delegate = self
        }
        else if let addListItemViewController = navigationController.topViewController as? AddListItemViewController
        {
            //if add list item view
            if tableView.indexPathForSelectedRow != nil
            {
                if let row = tableView.indexPathForSelectedRow?.row
                {
                    addListItemViewController.business = businesses[row]
                }
            }
        }
    }
    
    func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject])
    {
        //set values of filters
        let categories = filters["categories"] as? [String]
        let searchTerm = filters["search"] as? String
        let location = filters["location"] as? String
        
        if(location != "")
        {
            //search with user current location if no supplied location + filters
            Business.searchWithTerm(searchTerm!, location: location!, sort: nil, categories: categories, deals: nil)
            {(businesses: [Business]?, NSError) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
        else
        {
            if CLLocationManager.authorizationStatus() != .authorizedAlways
            {
                businesses = nil
            }
            else
            {
                //else search with selected location + filters
                Business.searchWithTerm(searchTerm!, lat: self.locValue.latitude, long: self.locValue.longitude, sort: nil, categories: categories, deals: nil, completion: { (businesses: [Business]?, error: NSError?) -> Void in
                    self.businesses = businesses
                    self.tableView.reloadData()
                })
            }
        }
    }
}
