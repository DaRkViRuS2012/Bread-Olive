//
//  DetailsController.swift
//  IDamus
//
//  Created by Nour  on 3/29/16.
//  Copyright © 2016 Kode. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SCLAlertView

class DetailsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var itmCntLbl: UILabel!
    @IBOutlet weak var CommentsTxt: UITextView!
    
    
    var pending:UIAlertController!
    
    var items = [orderMeals]()
    
    var ordId = 0
    var totalPrice = 0.0
    var totalCnt = 0
    
    var clientCmnt=""
    

    
    
    @IBAction func dismiss(sender: UIButton) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPrice = 0.0
        totalCnt=0
        
        tableView.tableHeaderView = UIView()
        let btnName = UIButton()
        
        btnName.setImage(UIImage(named: "Delete-50"), forState: .Normal)
        
        
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(DetailsController.dismiss(_:)), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = rightBarButton
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        updateArrayMenuOptions()
        CommentsTxt.text=clientCmnt
        
        
    }
    
    func updateArrayMenuOptions(){
        
        
        
        
        //order_details?order_id=3&access_token=df89156c4900d29848b4b954f86493bb899f5b8f
        
        let access_token = Globals.user.access_token!
        let url = Settings.mainUrl + "order_details?order_id=\(ordId)&access_token=\(access_token)"
        Alamofire.request(.GET,url)
            .responseJSON { response in
                print(response.2.value)// result of response serialization
                
                switch (response.2)
                {
                case .Success:
                    
                    if let value = response.2.value {
                        let json = JSON(value)
                        print("JSON : \(json)")

                        let ord = orderDetails(dictionary: json.rawValue as! NSDictionary)
                        self.items = (ord?.meals)!
                 
                        self.CommentsTxt.text = ord?.order![0].comments
                        self.tableView.reloadData()
                        
                        for i in 0..<self.items.count {
                            
                            self.totalCnt = self.totalCnt + Int(self.items[i].quantity!)!
                            self.totalPrice = self.totalPrice + Double(self.items[i].price!)! * Double(self.items[i].quantity!)!
                            
                        }
                        self.itmCntLbl.text = String(self.items.count)+"/"+String(self.totalCnt)
                        self.totalPriceLbl.text = String(self.totalPrice)
                        
                    }
                    break
                case .Failure:
                    let result = response.2.debugDescription
                    if let value = response.2.value {
                        let json = JSON(value)
                        let res = String(json)
                        if res == "false"{
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                kTitleFont: UIFont(name: "HelveticaNeue", size: 16)!,
                                kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
                                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 12)!,
                                showCloseButton: true
                            )
                            
                            let alert = SCLAlertView(appearance: appearance)
                            
                            
                            alert.showTitle(
                                "", // Title of view
                                subTitle: "Some thing goes wrong !", // String of view
                                duration: 2.0, // Duration to show before closing automatically, default: 0.0
                                completeText: "Try again", // Optional button value, default: ""
                                style: SCLAlertViewStyle.Error, // Styles - see below.
                                colorStyle: 0xA429FF,
                                colorTextButton: 0xFFFFFF
                            )
                            
                        }
                    }
                    if(result.containsString("The Internet connection appears to be offline"))
                    {
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 16)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 12)!,
                            showCloseButton: false
                        )
                        
                        let alert = SCLAlertView(appearance: appearance)
                        
                        
                        alert.showTitle(
                            "", // Title of view
                            subTitle: "check your Connection \nand try again !", // String of view
                            duration: 2.0, // Duration to show before closing automatically, default: 0.0
                            completeText: "Try again", // Optional button value, default: ""
                            style: SCLAlertViewStyle.Error, // Styles - see below.
                            colorStyle: 0xA429FF,
                            colorTextButton: 0xFFFFFF
                        )
                        
                        
                    }
                    
                }
                
        }

        
        

        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : detailsCell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath) as! detailsCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        let item = self.items[indexPath.row]
        cell.ItmCount.text = item.quantity!
        cell.ItmPrice.text = item.price!
        cell.ItmName.text = item.name!
    
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func pop(sender:UIButton){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    
    @IBAction func HandelReorder(sender: UIButton) {
        
        
    }
    
    
    
    
    
    
}













