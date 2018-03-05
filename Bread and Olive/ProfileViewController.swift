//
//  ViewController.swift
//  Bread and olive
//
//  Created by Nour  on 8/5/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SCLAlertView
import SwiftyJSON
import GoogleMaps
import Material
import SteviaLayout
class ProfileViewController: UIViewController {
    
    
    var id = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.loadData()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func close() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    func viewload(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.close),name:"close", object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let headerViewController = storyboard
            .instantiateViewControllerWithIdentifier("HeaderViewController")
        
        let firstViewController = AppMenuController(rootViewController: MenuListViewController())
        firstViewController.title = "Menu"
        
        
        
        let secondViewController = storyboard
            .instantiateViewControllerWithIdentifier("InfoViewController")
        secondViewController.title = "Map"
        
        
        let segmentedViewController = SJSegmentedViewController(headerViewController: headerViewController,
                                                                segmentControllers: [firstViewController,
                                                                    secondViewController])
        
        
        
        
        self.navigationController?.navigationBar.statusBarStyle = .LightContent
        self.navigationController!.navigationBar.translucent = true
        segmentedViewController.navigationItem.title = Globals.res.restaurant_name
        segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
        
        
        let shareButton = IconButton()
        shareButton.pulseColor = MaterialColor.white
        shareButton.setImage(UIImage(named:"ic_favorite_border_white")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        shareButton.setImage(UIImage(named:"ic_favorite_white")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Selected)
        shareButton.addTarget(self, action: #selector(handelFollow), forControlEvents: UIControlEvents.TouchUpInside)
        
        if Globals.islogedin == true{
            segmentedViewController.navigationItem.rightControls = [shareButton]
        }
        
        let backButton = IconButton()
        backButton.pulseColor = MaterialColor.white
        backButton.setImage(UIImage(named:"cm_arrow_back_white")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        backButton.addTarget(self, action: #selector(handelback), forControlEvents: UIControlEvents.TouchUpInside)
        
        segmentedViewController.navigationItem.leftControls = [backButton]
        
        segmentedViewController.navigationItem.backButton?.borderColor = MaterialColor.red.base
        
        let selected = Globals.favRes[self.id] != nil
        if selected {
            shareButton.selected = Globals.favRes[self.id]!
            let isfollow = Globals.favRes[self.id]!
        }
        self.navigationController?.pushViewController(segmentedViewController, animated: true)
        
        
    }
    
    
    
    
    func handelback(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    
    func handelFollow(sender:IconButton){
        
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
        
        let par:[String:AnyObject] = ["access_token": access_token!,"type":2,"id":self.id]
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
                            Globals.favRes[self.id] = select
                            sender.selected = Globals.favRes[self.id]!
                        }
                    }
                    break
                case .Failure:
                    
                    // print(response.2.data)
                    let result = response.2.debugDescription
                    
                    
                    
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
        
        
        
        
        
        print("ok")
        
        
    }
    
    
    
    
    
    
    
    
    func loadData()
    {
        
        let url = Settings.mainUrl + "restaurant_info?restaurant_id=\(self.id)"
        print(url)
        
        
        
        Alamofire.request(.GET, url, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                switch (response.2)
                {
                case .Success:
                    
                    if let value = response.2.value {
                        let json = JSON(value)
                        
                        let rest = Restaurants.modelsFromDictionaryArray(json.rawValue as! NSArray)
                        Globals.res = rest[0]
                        Globals.res.restaurant_id = self.id
                        self.viewload()
                        
                        print("JSON: \(json)")
                    }
                    break
                case .Failure:
                    
                    // print(response.2.data)
                    let result = response.2.debugDescription
                    if(result.containsString("no row"))
                    {
                        
                        
                        
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

