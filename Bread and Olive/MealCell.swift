//
//  MealCell.swift
//  Bread and Olive
//
//  Created by Nour  on 8/20/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import Material
import Kingfisher
class MealCell: UITableViewCell {
    
    
    
    var img = "" {
    
        didSet{
        
            var url = Settings.imageUrl + img
            url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            imagview!.kf_setImageWithURL(NSURL(string: url))
        
        }
    
    }
    
    
    var name  = ""{
    
    
        didSet{
        
        nameLbl.text = name
        
        }
    }
    
    var component = "" {
    
        didSet{
        
        componentLbl.text = component
        }
    
    }
    
    var price = ""{
    
        didSet{
        
            priceLbl.text = price
        }
    }
    
    var type = "" {
    
    
        didSet{
        
        typeLbl.text = type
        
        }
    }
    
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var componentLbl: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var imagview: UIImageView!
    
    @IBOutlet weak var typeLbl: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        imagview.layer.cornerRadius = 35
        imagview.layer.masksToBounds = true
        imagview.layer.borderWidth = 1
        imagview.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
