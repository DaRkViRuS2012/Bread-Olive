//
//  MenuListViewController.swift
//  Bread and Olive
//
//  Created by Nour  on 8/24/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import Material
import SCLAlertView
import SwiftyJSON
import Alamofire

class MenuListViewController: UIViewController {
    
    private var tableView: UITableView!
    var mealList = [Meals]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        getMenuList()
    }
    
    
    func prepareView(){
        let menuBtn = self.menuController?.menuView.menu.views![0] as! FabButton
        menuBtn.addTarget(self, action: #selector(handelBasket), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func handelBasket(){
        if Globals.islogedin == true
        {
            
            let storyvoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyvoard.instantiateViewControllerWithIdentifier("BasketView") as! BasketViewController
            vc.items = mealList
            self.presentViewController(vc, animated: true, completion: nil)
            print("fdg")
            
        }
        else
        {
            
            let refreshAlert = UIAlertController(title: "", message: "You have to be Loged in!", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Log in!", style: .Default, handler: { (action: UIAlertAction!) in
                
                let vc  = LoginViewController()
                Globals.isPushed = true
            
                let navigationController: AppNavigationController = AppNavigationController(rootViewController: vc)
                self.presentViewController(navigationController, animated: true, completion: nil)
            
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
            }))
            self.presentViewController(refreshAlert, animated: true, completion:nil)
            
            
         
            
        }
    }
    
    
    private func prepareTableView() {
        tableView = UITableView()
        let nib = UINib(nibName: "MealCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "mealCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .Interactive
        tableView.tableFooterView = MaterialView()
        // Use Layout to easily align the tableView.
        view.layout(tableView).edges()
        
        tableView.reloadData()
    }
    //meals_list?restaurant_id=1
    func getMenuList(){
        
        let id = Globals.res.restaurant_id!
        let url = Settings.mainUrl + "meals_list?restaurant_id=\(id)"
        print(url)
        
        Alamofire.request(.GET, url, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                switch (response.2)
                {
                case .Success:
                    
                    
                    if let value = response.2.value {
                        let json = JSON(value)
                        self.mealList = Meals.modelsFromDictionaryArray(json.rawValue as! NSArray)
                        self.prepareTableView()
                        
                    }
                    break
                case .Failure:
                    
                    // print(response.2.data)
                    let result = response.2.debugDescription
                    if(result.containsString("no row"))
                    {
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            showCloseButton: false
                        )
                        
                        let alert = SCLAlertView(appearance: appearance)
                        
                        
                        alert.showTitle(
                            "", // Title of view
                            subTitle: "User name or password are incorrect !", // String of view
                            duration: 2.0, // Duration to show before closing automatically, default: 0.0
                            completeText: "Try again", // Optional button value, default: ""
                            style: SCLAlertViewStyle.Error, // Styles - see below.
                            colorStyle: 0xA429FF,
                            colorTextButton: 0xFFFFFF
                        )
                        
                    }
                    if(result.containsString("The Internet connection appears to be offline"))
                    {
                        
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
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




extension MenuListViewController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealList.count
    }
    
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MealCell = tableView.dequeueReusableCellWithIdentifier("mealCell", forIndexPath: indexPath) as! MealCell
        let meal = mealList[indexPath.row]
        
        cell.name = meal.meal_name!
        cell.type = meal.type_name!
        cell.price = meal.price!
        if Globals.islogedin == true{
        cell.likeBtn.addTarget(self, action: #selector(handelLike), forControlEvents: UIControlEvents.TouchUpInside)
        cell.likeBtn.selected = meal.liked
        }
        else{
        cell.likeBtn.hidden = true
        }
        return cell
        
    }
    
    func handelLike(sender:UIButton){
            let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
            if indexPath != nil {
           
                let id = mealList[indexPath!.row].meal_id
                var select = true
                var tag = "add_favorites"
                
                if sender.selected == true
                {
                    tag = "delete_favorites"
                    select = false
                    
                }
                let url = Settings.mainUrl + tag
                print(url)
                let access_token = Globals.user.access_token
                
                let par:[String:AnyObject] = ["access_token": access_token!,"type":1,"id":id!]
                print(par)
                Alamofire.request(.POST, url, parameters: par)
                    .responseJSON { response in
                        
                        switch (response.2)
                        {
                        case .Success:
                            
                            if let value = response.2.value {
                                let json = JSON(value)
                                print("JSON: \(json)")
                                
                                if let _ = json["Error Msg"].string{
                                    
                                }else
                                {
                                    Globals.favMeal[id!] = select
                                    sender.selected = Globals.favMeal[id!]!
                                }
                            }
                            break
                        case .Failure:
                            
                            // print(response.2.data)
                            let result = response.2.debugDescription
                            
                            print(result)
                            
                            if(result.containsString("The Internet connection appears to be offline"))
                            {
                                
                                let appearance = SCLAlertView.SCLAppearance(
                                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
}



extension MenuListViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
}