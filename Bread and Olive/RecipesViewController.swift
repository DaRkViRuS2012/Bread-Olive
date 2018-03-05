/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of Material nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material
import Alamofire
import SwiftyJSON
import SCLAlertView


class RecipesViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    /// A list of all the data source items.
    private var mealsdataSourceItems = Array<MaterialDataSourceItem>()
    private var resdataSourceItems = Array<MaterialDataSourceItem>()
    var list:FavoritesList!
    /// A tableView used to display items.
    private var tableView: UITableView!
    
    
    private var menuButton: IconButton!
    
    
    /// NavigationBar search button.
    private var searchButton: IconButton!
    
    
    
    
    
    func prepareView() {
        view.backgroundColor = MaterialColor.white
        prepareMenuButton()
        prepareSearchButton()
        prepareNavigationItem()
        
    }
    
    /// Handles the menuButton.
    internal func handleMenuButton() {
        navigationDrawerController?.openLeftView()
    }
    
    /// Handles the searchButton.
    internal func handleSearchButton() {
        
        let vc: AppSearchBarController = AppSearchBarController()
        vc.modalTransitionStyle = .CrossDissolve
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Prepares the menuButton.
    private func prepareMenuButton() {
        let image: UIImage? = UIImage(named:"cm_menu_white")
        menuButton = IconButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.setBackgroundImage(image, forState: .Normal)
        menuButton.setBackgroundImage(image, forState: .Highlighted)
        menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
    }
    
    
    
    /// Prepares the searchButton.
    private func prepareSearchButton() {
        let image: UIImage? = UIImage(named: "cm_search_white")
        searchButton = IconButton()
        searchButton.pulseColor = MaterialColor.white
        searchButton.setImage(image, forState: .Normal)
        searchButton.setImage(image, forState: .Highlighted)
        searchButton.addTarget(self, action: #selector(handleSearchButton), forControlEvents: .TouchUpInside)
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Favorites"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
        
        navigationItem.leftControls = [menuButton]
        navigationItem.rightControls = [searchButton]
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        if Globals.islogedin == true{
            
            prepareItems()
            
        }
        
        prepareTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Stops the tableView contentInsets from being automatically adjusted.
        if Globals.islogedin == true{
            
            prepareItems()
            
        }
        edgesForExtendedLayout = .None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Enable the NavigationDrawer.
        navigationDrawerController?.enabled = true
        (menuController as? AppMenuController)?.showMenuView()
    }
    
    /// Prepares the items Array.
    
    
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
    
    
    func prepareList(){
        
        mealsdataSourceItems.removeAll()
        resdataSourceItems.removeAll()
        for meal in list.meals! {
            Globals.favMeal[meal.meal_id!] = true
            print(Globals.favMeal)
            mealsdataSourceItems.append( MaterialDataSourceItem(
                data: [
                    "title": "\(meal.name!)",
                    "image": "AssortmentOfDessert"
                ]
                ))
        }
        for res in list.restaurants! {
             Globals.favRes[res.restaurant_id!] = true
            print(Globals.favRes)
            resdataSourceItems.append( MaterialDataSourceItem(
                data: [
                    "title": "\(res.restaurant_name!)",
                    "image": "AssortmentOfDessert"
                ]
                ))
        }
        tableView.reloadData()
        
    }
    
    private func prepareItems() {
        
        let access_token = Globals.user.access_token!
        let url = Settings.mainUrl + "get_favorites?access_token=\(access_token)"
        
        Alamofire.request(.GET,url)
            .responseJSON { response in
                print(response.2.value)// result of response serialization
                
                switch (response.2)
                {
                case .Success:
                    
                    if let value = response.2.value {
                        let json = JSON(value)
                        print("JSON : \(json)")
                        self.list = FavoritesList(dictionary: json.rawValue as! NSDictionary)
                        self.prepareList()
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
    
    /// Prepares view.
    
    /// Prepares the tableView.
    private func prepareTableView() {
        tableView = UITableView()
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = MaterialView()
        // Use Layout to easily align the tableView.
        view.layout(tableView).edges()
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.image = MaterialIcon.cm.photoLibrary
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.white, forState: .Selected)
    }
}

/// TableViewDataSource methods.
extension RecipesViewController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return mealsdataSourceItems.count
            
        }
        if section == 1
        {
            
            return resdataSourceItems.count
        }
        return 0
        
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "MaterialTableViewCell")
        var item: MaterialDataSourceItem!
        if indexPath.section == 0{
            item = mealsdataSourceItems[indexPath.row]
        }
        if indexPath.section == 1{
            
            item = resdataSourceItems[indexPath.row]
        }
        if let data: Dictionary<String, AnyObject> =  item.data as? Dictionary<String, AnyObject> {
            cell.selectionStyle = .None
            cell.textLabel?.text = data["title"] as? String
            cell.textLabel?.font = RobotoFont.lightWithSize(14)
            cell.detailTextLabel?.text = data["detail"] as? String
            cell.detailTextLabel?.font = RobotoFont.lightWithSize(12)
            cell.detailTextLabel?.textColor = MaterialColor.grey.darken1
            cell.imageView?.layer.cornerRadius = 32
            cell.imageView?.image = UIImage(named: data["image"] as! String)?.crop(toWidth: 64, toHeight: 64)
        }
        
        return cell
    }
    
    /// Prepares the header within the tableView.
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, view.bounds.width, 48))
        header.backgroundColor = MaterialColor.grey.darken1
        
        let label: UILabel = UILabel()
        label.font = RobotoFont.medium
        label.textColor = MaterialColor.white
        if section == 0
        {
            label.text = "Favorites Meals"
        }
        if section == 1
        {
            label.text = "Favorite Resturants"
            
        }
        header.layer.borderColor = MaterialColor.grey.base.CGColor
        header.layer.borderWidth = 1
        header.layout(label).edges(left: 24)
        
        return header
    }
}

/// UITableViewDelegate methods.
extension RecipesViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    /// Sets the tableView header height.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    
    func openbasket() {
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let popoverContent = storyboard.instantiateViewControllerWithIdentifier("BasketItemsViewController") as! BasketItemsViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(500,600)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(self.view.frame.height / 2,self.view.frame.width / 2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
  
    
            switch indexPath.section {
            case 0:
               let m = list.meals![indexPath.row]
                
                let meal = Meals(name: m.name!,id: m.meal_id!,cnt: 1,prc: m.price!)
                Globals.Basket.append(meal)
                openbasket()
            case 1:
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc =  storyboard.instantiateViewControllerWithIdentifier("ProfileView") as! ProfileViewController
                vc.id = list.restaurants![indexPath.row].restaurant_id!
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                return
            }
        
        
    }
}
