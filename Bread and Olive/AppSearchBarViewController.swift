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

/*
 The following is an example of using a SearchBarController to control the
 flow of your application.
 */

import UIKit
import Material
import SteviaLayout
import SCLAlertView
import Alamofire
import SwiftyJSON
class AppSearchBarController: UIViewController, UITextFieldDelegate {
    
    
    private var searchBar: SearchBar!
    var id = ""
    var searchlist:SearchList!
    var mealList = [Meals]()
    var resList = [Restaurants]()
    
    private var dataSourceItems: Array<MaterialDataSourceItem>!
    
    /// A tableView used to display Bond entries.
    private var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(dataSourceItems: Array<MaterialDataSourceItem>) {
        self.init(nibName: nil, bundle: nil)
        self.dataSourceItems = dataSourceItems
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    /// Prepares view.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /// Prepares the tableView.
    private func prepareTableView() {
        tableView = UITableView()
        let nib = UINib(nibName: "MealCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "mealCell")
        let nib1 = UINib(nibName: "resCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "resCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .Interactive
        tableView.tableFooterView = MaterialView()
        // Use Layout to easily align the tableView.
        view.layout(tableView).edges()
    }
    
    
    /// TableViewDataSource methods.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prepareView()
        prepareView()
        prepareTableView()
        self.view.backgroundColor = MaterialColor.red.base
        prepareSearchBar()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarController?.statusBarStyle = .Default
        navigationDrawerController?.enabled = false
        self.navigationController!.navigationBar.translucent = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.textField.resignFirstResponder()
        navigationDrawerController?.enabled = true
    }
    
    /// Toggle SideSearchViewController left UIViewController.
    internal func handleBackButton() {
        searchBar.textField.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func prepareSearchBar() {
        searchBar = SearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.backgroundColor = MaterialColor.white
        searchBar.textField.autocorrectionType = .No
        searchBar.textField.autocapitalizationType = .None
        searchBar.textField.delegate = self
        searchBar.textField.returnKeyType = .Search
        
        let image: UIImage? = UIImage(named: "ic_arrow_back_white")?.imageWithRenderingMode(.AlwaysTemplate)
        
        // Back button.
        let backButton: IconButton = IconButton()
        backButton.pulseColor = MaterialColor.grey.base
        backButton.tintColor = MaterialColor.grey.darken4
        backButton.setImage(image, forState: .Normal)
        backButton.setImage(image, forState: .Highlighted)
        backButton.addTarget(self, action: #selector(handleBackButton), forControlEvents: .TouchUpInside)
        
        // More button.
        let image1 = UIImage(named: "ic_more_horiz_white")?.imageWithRenderingMode(.AlwaysTemplate)
        let moreButton: IconButton = IconButton()
        moreButton.pulseColor = MaterialColor.grey.base
        moreButton.tintColor = MaterialColor.grey.darken4
        moreButton.setImage(image1, forState: .Normal)
        moreButton.setImage(image1, forState: .Highlighted)
        
        searchBar.clearButton.setImage(UIImage(named:"cm_close_white")?.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
        searchBar.textField.delegate = self
        searchBar.leftControls = [backButton]
        searchBar.rightControls = [moreButton]
        
        
        searchBar.clearButton.tap({
            
        })
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        if searchBar.textField.text?.characters.count >= 0 {
            let word = searchBar.textField.text
            search(word!)
        }
        return true
    }
    
    
    
    func search(string:String)
    {
        
        
        let url = Settings.mainUrl + "search_string?language=ar&string=\(string)"
        print(url)
        
        let url1 = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        print(url1)
        
        Alamofire.request(.GET, url1, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                switch (response.2)
                {
                case .Success:
                    
                    
                    if let value = response.2.value {
                        let json = JSON(value)
                        self.searchlist = SearchList(dictionary: json.rawValue as! NSDictionary)
                        self.mealList = self.searchlist.meals
                        self.resList  = self.searchlist.restaurants
                        self.tableView.reloadData()
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




extension AppSearchBarController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mealList.count
        case 1:
            return resList.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Meals"
        case 1:
            return "Resturants"
        default:
            return ""
        }
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell: MealCell = tableView.dequeueReusableCellWithIdentifier("mealCell", forIndexPath: indexPath) as! MealCell
            let meal = mealList[indexPath.row]
            
            cell.name = meal.meal_name!
            cell.type = meal.type_name!
            cell.price = meal.price!
            cell.component = meal.components_names_ar!
            cell.likeBtn.hidden = true
            
            return cell
        }
        if indexPath.section == 1{
            
            let cell: resCell = tableView.dequeueReusableCellWithIdentifier("resCell", forIndexPath: indexPath) as! resCell
            let res = resList[indexPath.row]
            if let _ = res.logo_url{
                cell.img = res.logo_url!
            }
            cell.name = res.restaurant_name!
            cell.phone = res.phone!
            return cell
            
        }
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc =  storyboard.instantiateViewControllerWithIdentifier("ProfileView") as! ProfileViewController
        switch indexPath.section {
        case 0:
            vc.id = mealList[indexPath.row].restaurant_id!
        case 1:
            vc.id = resList[indexPath.row].restaurant_id!
        default:
            vc.id = "0"
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    /// Prepares the header within the tableView.
    /*   func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let header = UIView(frame: CGRectMake(0, 0, view.bounds.width, 48))
     header.backgroundColor = MaterialColor.white
     let line = UIView(frame: CGRectMake(0, 0, view.bounds.width - 20, 1))
     header.addSubview(line)
     line.backgroundColor = MaterialColor.grey.darken1
     line.layer.cornerRadius = 3
     line.layer.masksToBounds = true
     let label: UILabel = UILabel()
     label.font = RobotoFont.medium
     label.textColor = MaterialColor.grey.darken1
     label.text = "Recommendations"
     header.layout(line).edges(top: 45)
     header.layout(label).edges(left: 24)
     return header
     }
     */
    
}

extension AppSearchBarController: TextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        print("Begin searching....")
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("End searching....")
    }
}



/// UITableViewDelegate methods.
extension AppSearchBarController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    /// Sets the tableView header height.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
