//
//  BusinessCell.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell
{
    //make yelp cell layout
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    //init values
    var business:Business!
        {
        didSet
        {
            nameLabel.text = business.name
            if(business.imageURL != nil)
            {
                thumbImageView.setImageWith(business.imageURL! as URL)
            }
            
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWith(business.ratingImageURL! as URL)
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        imageView?.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
}
