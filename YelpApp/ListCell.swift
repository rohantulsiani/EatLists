//
//  ListCell.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell
{
    //each list has a name and image
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var imageViewer: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
