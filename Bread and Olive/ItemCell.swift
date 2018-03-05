//
//  ItemCell.swift
//  eDamus_Client
//
//  Created by Nour  on 4/29/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import Foundation
import UIKit


class ItemCell : UITableViewCell {
    
    var img = "" {
        
        didSet{
            
            var url = Settings.imageUrl + img
            url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            itmImage.kf_setImageWithURL(NSURL(string: url))
            
        }
        
    }
    
    
    
    @IBOutlet weak var itmImage: UIImageView!
    @IBOutlet weak var ItmName: UILabel!
    @IBOutlet weak var decBtn: UIButton!
    @IBOutlet weak var incBtn: UIButton!
    @IBOutlet weak var ItmPrice: UILabel!
    @IBOutlet weak var ItmCnt: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itmImage.layer.masksToBounds = true
        itmImage.layer.borderWidth = 1
        itmImage.layer.cornerRadius = 35
        itmImage.layer.borderColor = UIColor.blackColor().CGColor
    }
    
}