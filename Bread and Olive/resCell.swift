//
//  resCell.swift
//  Bread and Olive
//
//  Created by Nour  on 8/21/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit

class resCell: UITableViewCell {

    
    
    var img = "" {
        
        didSet{
            
            var url = Settings.imageUrl + img
            url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            imageview!.kf_setImageWithURL(NSURL(string: url))
            
        }
        
    }
    
    
    var name  = ""{
        
        
        didSet{
            
            nameLbl.text = name
            
        }
    }
    
    var phone = ""{
    
        didSet{
        
        phoneLbl.text = phone
        }
    
    }
 

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageview.layer.cornerRadius = 35
        imageview.layer.masksToBounds = true
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = UIColor.blackColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
