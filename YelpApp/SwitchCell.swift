//
//  SwitchCell.swift
//  YelpApp
//
//  Created by Rohan Tulsiani on 12/6/16.
//  Email: tulsiani@usc.edu
//  Copyright © 2016 Rohan Tulsiani. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate
{
    @objc optional func switchCell(_ switchCell:SwitchCell, didChangeValue value:Bool)
    
}

class SwitchCell: UITableViewCell
{
    //for filters view
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate:SwitchCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    //call delegates implementation of switch cell if value of switch changes
    @IBAction func onSwitchChanged(_ sender: AnyObject)
    {
        delegate?.switchCell?(self, didChangeValue: onSwitch.isOn)
    }
}
