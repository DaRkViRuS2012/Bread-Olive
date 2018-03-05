//
//  BasketItemsViewController.swift
//  eDamus_Client
//
//  Created by Nour  on 5/1/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import KCFloatingActionButton
import SwiftyJSON
import Alamofire
import SCLAlertView

class BasketItemsViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource , KCFloatingActionButtonDelegate{
    
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var commentsTxt: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCnt: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var deliveryCost: UILabel!
    
    @IBOutlet weak var deliveryLbl: UILabel!
    
    //  var basket = Globals.Basket
    
    @IBAction func dismiss(sender: UIButton) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    var pending:UIAlertController!
    var total = 0.0
    
    func alertShow(){
        
        pending = UIAlertController(title: nil, message: "Please wait\n\n\n", preferredStyle: .Alert)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.center = CGPointMake(130.5, 65.5);
        indicator.color = UIColor.blackColor()
        pending.view.addSubview(indicator)
        indicator.userInteractionEnabled = false
        indicator.startAnimating()
        self.presentViewController(pending, animated: true, completion: nil)
    }
    
    func alerthide(){
        
        self.pending.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBasket()
        self.title = "Check Out"
        let btnName = UIButton()
        
        btnName.setImage(UIImage(named: "Delete-50"), forState: .Normal)
        
        
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(BasketItemsViewController.dismiss(_:)), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = rightBarButton
        self.tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //  self.setNavigationBarItem()
        //  updateArrayMenuOptions()
        self.reload()
        
    }
    
    func checkBasket(){
    
        if Globals.Basket.count > 0 {
        btn.enabled = true
        }
        else
        {
        btn.enabled = false
        }
    
    }
    
    var basket = [Meals]()
    
    
    func reload(){
        
        
     //   self.deliveryCost.text = "0"
        
        basket = Globals.Basket
        var cnt = 0
        var totalPrice = 0.0
        
        for i in 0 ..< basket.count{
            totalPrice += Double(Globals.Basket[i].price!)! * Double(Globals.Basket[i].itmcnt)
            
            cnt += basket[i].itmcnt
            
        }
     //   let deliveryCost = Double(self.deliveryCost.text!)
       // totalPrice += deliveryCost!
        self.totalPrice.text = String(totalPrice)
        let basketCnt = basket.count
        self.totalCnt.text = "\(basketCnt)/\(cnt)"
        
        self.tableView.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.Basket.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell  = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath)
        
        let item = Globals.Basket[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        let itmImage:UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let ItmName:UILabel = cell.contentView.viewWithTag(2) as! UILabel
        let ItmPrice:UILabel = cell.contentView.viewWithTag(3) as! UILabel
        let ItmCount:UILabel = cell.contentView.viewWithTag(4) as! UILabel
        let addBtn:UIButton = cell.contentView.viewWithTag(5) as! UIButton
        
        
        ItmName.text = item.meal_name
        
        
        itmImage.layer.cornerRadius = 20
        itmImage.clipsToBounds = true
        itmImage.layer.borderWidth = 3
        itmImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        ItmPrice.text = item.price
        ItmCount.text = String(item.itmcnt)
        
        
        addBtn.addTarget(self, action: #selector(BasketViewController.rem(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
        
    }
    
    
    func rem(sender:UIButton){
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let item = Globals.Basket[indexPath!.row]
            item.itmcnt = 0
            let index = Globals.find(Globals.Basket, item: item )
            Globals.Basket.removeAtIndex(index)
            
            self.reload()
        }
    }
    
    
    
    
    func creatJson(data:Dictionary<String,AnyObject>) -> String? {
        
        let parameters = NSMutableDictionary()
        
        for (key,value) in data{
            parameters.setValue(value, forKey: key)
        }
        
        let jsonData: NSData
        
        do{
            
            jsonData = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions())
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            return jsonString
        } catch {
            return nil
            
        }
    }
    
    
    
    
    
    @IBAction func check(sender: UIButton) {
        if(Globals.islogedin == false)
        {
            
            let refreshAlert = UIAlertController(title: "", message: "You have to be Loged in!", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Log in!", style: .Default, handler: { (action: UIAlertAction!) in
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "I don't have an account !", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.performSegueWithIdentifier("SignUpSegue", sender: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                refreshAlert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(refreshAlert, animated: true, completion:nil)
            
        }
        else
        {
            let access_token = Globals.user.access_token
            let comment = commentsTxt.text?.trim()
            
            var mls:[AnyObject] = []
            
            for item in basket{
                let x = Int(item.meal_id!) as! AnyObject
                let ml = ["meal_id":x,"quantity": item.itmcnt]
                mls.append(ml)
            }
            
            print(mls)
        
            let pt:[String:AnyObject] = ["meals":mls,"comments":comment!]
            print(pt)
            
            let par:[String:AnyObject] = ["access_token":access_token!,"order":creatJson(pt)!]
            print(par)
      
            
            ////////////////////////////////////////////
            let url = Settings.mainUrl + "order"
            Alamofire.request(.POST,url,parameters: par)
                .responseJSON { response in
                    print(response.2.value)// result of response serialization
                 
                    switch (response.2)
                    {
                    case .Success:
                        
                    if let value = response.2.value {
                        let json = JSON(value)
                        print("JSON : \(json)")
                        let result = String(json)
                        print(result)
                        let refreshAlert = UIAlertController(title: "Your order has been sent\n", message: "Your orderd ID is \(json["order_id"])\nthe total cost of is \(json["total"])\n taxes : \(json["tax"])\n", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Ok Thanks!", style: .Default, handler: { (action: UIAlertAction!) in
                            self.dismissViewControllerAnimated(false, completion: nil)
                            
                        }))
                        
                        self.presentViewController(refreshAlert, animated: true, completion:nil)
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
        
        
    }
    
    
}
