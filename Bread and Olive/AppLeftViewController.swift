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
 The following is an example of setting a UITableView as the LeftViewController
 within a NavigationDrawerController.
 */

import UIKit
import Material


protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index : Int32)
}


private struct Item {
    var text: String
    var imageName: String
}

class AppLeftViewController: UIViewController {
    /// A tableView used to display navigation items.
    private let tableView: UITableView = UITableView()
    
    /// A list of all the navigation items.
    private var items: Array<Item> = Array<Item>()
    var delegate : SlideMenuDelegate?
    let nameLabel: UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeState),name:"change", object: nil)
        
        prepareView()
        prepareCells()
        prepareTableView()
    }
    
    
    func showView(VC:UIViewController) {
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func changeState(){
    
        if Globals.islogedin == true {
        items[0].text = "Log out"
            if let user = Globals.user{
            
            nameLabel.text = user.email
            }
        }
        else
        {
        items[0].text = "Log in"
        nameLabel.text = ""
        }
        tableView.reloadData()
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
         The dimensions of the view will not be updated by the side navigation
         until the view appears, so loading a dyanimc width is better done here.
         The user will not see this, as it is hidden, by the drawer being closed
         when launching the app. There are other strategies to mitigate from this.
         This is one approach that works nicely here.
         */
  
        prepareProfileView()
    }
    
    override func viewWillAppear(animated: Bool) {
    
    }
    
 
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.grey.darken4
    }
    
    /// Prepares the items that are displayed within the tableView.
    private func prepareCells() {
        items.removeAll()
        
        items.append(Item(text: "Log In", imageName: "ic_today"))
        items.append(Item(text: "Near me", imageName: "ic_place_white"))
        items.append(Item(text: "Home", imageName: "ic_home_white"))
        if Globals.islogedin == true{
        items.append(Item(text: "My orders", imageName:"ic_visibility_white"))
        }
    }
    
    /// Prepares profile view.
    private func prepareProfileView() {
        let backgroundView: MaterialView = MaterialView()
        backgroundView.image = UIImage(named: "MaterialBackground")
        
        let profileView: MaterialView = MaterialView()
        profileView.image = UIImage(named: "Profile9")?.resize(toWidth: 72)
        profileView.backgroundColor = MaterialColor.clear
        profileView.shape = .Circle
        profileView.borderColor = MaterialColor.white
        profileView.borderWidth = 3
        
        
        if Globals.islogedin{
            if let user = Globals.user {
            nameLabel.text = user.email
                
            }
        
        }
        nameLabel.textColor = MaterialColor.white
        nameLabel.font = RobotoFont.mediumWithSize(16)
        
        view.layout(profileView).width(72).height(72).top(30).centerHorizontally()
        view.layout(nameLabel).top(130).left(20).right(20)
    }
    
    /// Prepares the tableView.
    private func prepareTableView() {
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "MaterialTableViewCell")
        tableView.backgroundColor = MaterialColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        
        // Use Layout to easily align the tableView.
        view.layout(tableView).edges(top: 170)
    }
}

/// TableViewDataSource methods.
extension AppLeftViewController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = tableView.dequeueReusableCellWithIdentifier("MaterialTableViewCell", forIndexPath: indexPath) as! MaterialTableViewCell
        
        let item: Item = items[indexPath.row]
        
        cell.textLabel!.text = item.text
        cell.textLabel!.textColor = MaterialColor.grey.lighten2
        cell.textLabel!.font = RobotoFont.medium
        cell.imageView!.image = UIImage(named: item.imageName)?.imageWithRenderingMode(.AlwaysTemplate)
        cell.imageView!.tintColor = MaterialColor.grey.lighten2
        cell.backgroundColor = MaterialColor.clear
        
        return cell
    }
}

/// UITableViewDelegate methods.
extension AppLeftViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    /// Select item at row in tableView.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //   showView(LoginViewController())
        
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController as! AppNavigationDrawerController
        let root2 = root.rootViewController as! AppNavigationController
        
        switch indexPath.row {
        case 0:
            if Globals.islogedin == true {
            Globals.islogedin = false
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
                
            Globals.user = nil
            Globals.favMeal.removeAll()
            Globals.favRes.removeAll()
            items[0].text = "Log in"
            nameLabel.text = ""
            prepareCells()
            tableView.reloadData()
                let bottomNavigationController: RecipesViewController = RecipesViewController()
                let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
                let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
                UIApplication.sharedApplication().keyWindow?.rootViewController = navigationDrawerController
                
            self.navigationDrawerController?.closeLeftView()
            return
            }
            
            let bottomNavigationController: LoginViewController = LoginViewController()
           
            if root2.visibleViewController is LoginViewController{
                self.navigationDrawerController?.closeLeftView()
                return
            }
            items[0].text = "Log out"
            Globals.isPushed = false
            let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
            //  let menuController: AppMenuController = AppMenuController(rootViewController: navigationController)
            //   let statusBarController: StatusBarController = StatusBarController(rootViewController: menuController)
            let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
            UIApplication.sharedApplication().keyWindow?.rootViewController = navigationDrawerController
            
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let bottomNavigationController = storyboard.instantiateViewControllerWithIdentifier("GoogleMapAutoCompleteViewController") as! GoogleMapAutoCompleteViewController
            
            if root2.visibleViewController is GoogleMapAutoCompleteViewController{
                 self.navigationDrawerController?.closeLeftView()
                break
            }
        
            let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
            //  let menuController: AppMenuController = AppMenuController(rootViewController: navigationController)
            //   let statusBarController: StatusBarController = StatusBarController(rootViewController: menuController)
            let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
            UIApplication.sharedApplication().keyWindow?.rootViewController = navigationDrawerController
            
        case 2:
            let bottomNavigationController: RecipesViewController = RecipesViewController()
            if root2.visibleViewController is RecipesViewController{
                self.navigationDrawerController?.closeLeftView()
              break
            }
        
            let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
       
            let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
            UIApplication.sharedApplication().keyWindow?.rootViewController = navigationDrawerController
            
        case 3:
            
            let bottomNavigationController: myOrdersViewController = myOrdersViewController()
            if root2.visibleViewController is myOrdersViewController{
                self.navigationDrawerController?.closeLeftView()
                break
            }
            let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
            let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
            UIApplication.sharedApplication().keyWindow?.rootViewController = navigationDrawerController
            
            
        default:
            return
        }
        
    }
    
}





