//
//  BasketViewController.swift
//  eDamus_Client
//
//  Created by Nour  on 4/27/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import KCFloatingActionButton
import DZNEmptyDataSet
import Material
import SteviaLayout
class BasketViewController: UIViewController,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate ,UITableViewDelegate ,UIPopoverPresentationControllerDelegate,KCFloatingActionButtonDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totlaLbl : UILabel!
    
    
    private var containerView: UIView!
    
    /// Reference for SearchBar.
    private var searchBar: SearchBar!
    
    
    
    var spId:String!
    var items = [Meals]()
    var searchlist = [Meals]()
    
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
    
 
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.textField.resignFirstResponder()
        navigationDrawerController?.enabled = true
    }
    
    
    private func prepareSearchBar() {
        searchBar = SearchBar()
        searchView.sv(searchBar)
        searchView.layout(0,|searchBar|,0)
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
        
        searchBar.textField.addTarget(self, action: #selector(BasketViewController.searchAutocompleteEntriesWithSubstring), forControlEvents: UIControlEvents.EditingChanged)
        
        searchBar.clearButton.tap({
            
        })
        
    }

    internal func handleBackButton() {
        searchBar.textField.resignFirstResponder()
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(iTems:[Meals]) {
        self.init(nibName: nil, bundle: nil)
       self.items = iTems
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        prepareContainerView()
        prepareSearchBar()
        
        
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self
        
        let fab = KCFloatingActionButton()
        fab.itemButtonColor = MaterialColor.red.darken4
        fab.buttonColor = MaterialColor.red.darken4
        fab.plusColor = UIColor.whiteColor()
        
        fab.addItem("Delivery", icon: UIImage(named: "basket")!, handler: { item in
            self.openbasket()
            fab.close()
        })
        
     /*   fab.addItem("TakeAway", icon: UIImage(named: "delivery")!, handler: { item in
            self.openbasket()
            fab.close()
        })
 */
        
        fab.fabDelegate = self
        self.view.addSubview(fab)
        
        
        Globals.Basket.removeAll()
      //  updateArrayMenuOptions()
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")

        tableView.keyboardDismissMode = .Interactive
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        searchlist = items
    }
    
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(contentsOfFile: "ic_search_72pt")
    }
    
    
    @IBAction func endEditing() {
        view.endEditing(true)
    }
    
    func KCFABOpened(fab: KCFloatingActionButton) {
        print("FAB Opened")
    }
    
    func KCFABClosed(fab: KCFloatingActionButton) {
        print("FAB Closed")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //  self.setNavigationBarItem()
        self.reload()
        //tableView.reloadData()
    }
    
    
    func updateArrayMenuOptions(){
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            self.alertShow()
         //   self.searchlist = GetItems().getItems(self.spId)
            self.items = self.searchlist
            dispatch_async(dispatch_get_main_queue()) {
                
                self.tableView.reloadData()
                self.alerthide()
                self.totlaLbl.text = "\(self.total)"
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ItemCell  = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath) as! ItemCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        let item = items[indexPath.row]
        
        cell.ItmName.text = item.meal_name
        cell.ItmCnt.text = "\(item.itmcnt)"
        cell.ItmPrice.text = item.price
        
        cell.incBtn.addTarget(self, action: #selector(BasketViewController.add(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.decBtn.addTarget(self, action: #selector(BasketViewController.rem(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        return cell
        
    }
    
    
    
    func add(sender:AnyObject) {
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            let item = self.items[indexPath!.row]
            let index = Globals.find(Globals.Basket, item: item )
            
            
            //    let itmPrice = self.items[indexPath!.row].itmPrice
            //  self.total += itmPrice!
            self.items[indexPath!.row].itmcnt = self.items[indexPath!.row].itmcnt + 1
            
            
            if (index == -1)
            {
                Globals.Basket.append(item)
            }
            else{
                Globals.Basket[index] = item
            }
            
            self.reload()
        }
    }
    
    
    func rem(sender:AnyObject) {
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        if indexPath != nil {
            
            self.totlaLbl.text = "\(self.total)"
            
            let cnt = self.items[indexPath!.row].itmcnt
            if(cnt > 0)
            {
                let item = self.items[indexPath!.row]
                let index = Globals.find(Globals.Basket, item: item )
                
              
                self.items[indexPath!.row].itmcnt = self.items[indexPath!.row].itmcnt - 1
                if (cnt == 1 )
                {
                    Globals.Basket.removeAtIndex(index)
                }
                else
                {
                    Globals.Basket[index] = item
                }
                self.reload()
            }
            
        }
        
    

    }
    
    
    func reload(){
        self.total = 0
        for i in 0 ..< Globals.Basket.count{
            self.total += Double(Globals.Basket[i].price!)! * Double(Globals.Basket[i].itmcnt)
            //self.total = self.total + (Double(Globals.Basket[i].price) * Double(Globals.Basket[i].itmcnt))
            
        }
        self.totlaLbl.text = "\(self.total)"
        tableView.reloadData()
        
    }
    
    
    func openbasket() {
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("BasketItemsViewController"))! as UIViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(500,600)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(self.view.frame.height / 2,self.view.frame.width / 2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func clearBasket(sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "", message: "Clear your basket !!?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            for i in 0 ..< Globals.Basket.count{
                Globals.Basket[i].itmcnt = 0
            }
            Globals.Basket.removeAll()
            self.reload()
            //  JLToast.makeText("Done").show()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        self.presentViewController(refreshAlert, animated: true, completion:nil)
        
        
    }
    
    
    
    private func prepareView() {
        searchView.backgroundColor = MaterialColor.white
        
        
    }
    
    /// Prepares the containerView.
    
    
    
    /// Prepares the containerView.
    private func prepareContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        searchView.addSubview(containerView)
        
       // MaterialLayout.alignToParent(searchView, child: containerView, top: 0, left: 0, right: 0)
    }
    
    
    
    
    
    /// Prepares the toolbar
    private func prepareSearchBar2() {
        searchBar = SearchBar()
        containerView.addSubview(searchBar)
        searchBar.textField.autocapitalizationType = .None
        searchBar.textField.autocorrectionType = .No
        let image: UIImage? = MaterialIcon.cm.moreVertical
        
        // More button.
        let moreButton: IconButton = IconButton()
        moreButton.pulseColor = MaterialColor.grey.base
        moreButton.tintColor = MaterialColor.grey.darken4
        moreButton.setImage(image, forState: .Normal)
        moreButton.setImage(image, forState: .Highlighted)
        searchBar.textField.addTarget(self, action: #selector(BasketViewController.searchAutocompleteEntriesWithSubstring), forControlEvents: UIControlEvents.EditingChanged)
        /*
         To lighten the status bar - add the
         "View controller-based status bar appearance = NO"
         to your info.plist file and set the following property.
         */
        
        searchBar.leftControls = [moreButton]
        
    }
    
    
    func searchAutocompleteEntriesWithSubstring()
    {
        let substring = searchBar.textField.text!
        if(substring.characters.count > 0)
        {
            items.removeAll(keepCapacity: false)
            
            for item in searchlist
            {
                let myString:NSString! = (item.meal_name?.lowercaseString)! as NSString
                
                let substringRange :NSRange! = myString.rangeOfString(substring.lowercaseString)
                
                if (substringRange.location  != NSNotFound)
                {
                    items.append(item)
                }
            }
            
        }
        else
        {
            
            items = searchlist
        }
        
        tableView.reloadData()
    }
    
    
    
}




