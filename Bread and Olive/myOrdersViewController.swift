//
//  myOrdersViewController.swift
//  Bread and Olive
//
//  Created by Nour  on 9/15/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import Material
import Alamofire
import SwiftyJSON
import SteviaLayout
import SCLAlertView

class myOrdersViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate{
    
    let status = ["-1":"Rejected","0":"waiting","1":"proccessing","2":"Handled"]
    
    private var menuButton: IconButton!
    var tableView = UITableView()
    
    var orderlist = [orderList]()
    
    
    
    func prepareView() {
        // view.backgroundColor = MaterialColor.white
        prepareMenuButton()
        prepareNavigationItem()
        
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "orderCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        self.view.sv(tableView)
        view.layout(0,|tableView|,0)
        
    }
    
    
    /// Prepares the menuButton.
    private func prepareMenuButton() {
        let image: UIImage? = UIImage(named: "cm_menu_white")
        menuButton = IconButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
    }
    
    /// Handles the menuButton.
    internal func handleMenuButton() {
        navigationDrawerController?.openLeftView()
    }
    
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "My orders"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
        
        navigationItem.leftControls = [menuButton]
        //   navigationItem.rightControls = [switchControl, searchButton]
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    
    func loadData(){
        let access_token = Globals.user.access_token!
        let url = Settings.mainUrl + "my_orders?access_token=\(access_token)"
        Alamofire.request(.GET,url)
            .responseJSON { response in
                print(response.2.value)// result of response serialization
                
                switch (response.2)
                {
                case .Success:
                    
                    if let value = response.2.value {
                        let json = JSON(value)
                        print("JSON : \(json)")
                        
                        self.orderlist = orderList.modelsFromDictionaryArray(json.rawValue as! NSArray)
                        self.orderlist.sortInPlace({Int($0.0.order_id!)! > Int($0.1.order_id!)!})
                        self.tableView.reloadData()
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  orderlist.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! orderCell
        
        let order = orderlist[indexPath.row]
        
        cell.orderId.text = "order Id: \(order.order_id!)"
        cell.total.text = "total: \(order.total!)"
        cell.resName.text = order.restaurant_name!
        cell.status.text = status[order.status!]
        
        let date  = Double(order.date_time!)
        let theDate = NSDate(timeIntervalSince1970: date!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd-HH:mm:ss"
        cell.timeLbl.text = dateFormatter.stringFromDate(theDate)
        
    
        cell.detailsBtn.addTarget(self, action: #selector(orderDetails), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    
    
    func orderDetails(sender:UIButton)
    {
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let popoverContent = storyboard.instantiateViewControllerWithIdentifier("DetailsController") as! DetailsController
             popoverContent.ordId = Int(self.orderlist[indexPath!.row].order_id!)!
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            nav.title = self.orderlist[indexPath!.row].restaurant_name
            let popover = nav.popoverPresentationController
            popoverContent.preferredContentSize = CGSizeMake(500,600)
            popoverContent.title = self.orderlist[indexPath!.row].restaurant_name
            popover!.delegate = self
            popover!.sourceView = self.view
            popover!.sourceRect = CGRectMake(self.view.frame.height / 2,self.view.frame.width / 2,0,0)
            
            self.presentViewController(nav, animated: true, completion: nil)
        }
        
    }
    
    
    
    
}
