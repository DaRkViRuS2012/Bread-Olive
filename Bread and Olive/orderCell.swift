//
//  orderCell.swift
//  Bread and Olive
//
//  Created by Nour  on 9/15/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit

class orderCell: UITableViewCell {

    
    
    @IBOutlet weak var resName: UILabel!
    
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var detailsBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
