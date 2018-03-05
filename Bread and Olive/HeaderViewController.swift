//
//  HeaderViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 13/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//
import Material

import UIKit
import Alamofire
import SwiftyJSON
class HeaderViewController: UIViewController {
    
 
    var isfollow = false
    var image = ""{
        
        didSet{
            var url = Settings.imageUrl + image
            url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            imageView.kf_setImageWithURL(NSURL(string: url))
            
            
        }
        
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
   
        // Do any additional setup after loading the view.
        
    
    }
    
    
  /*
    
    @IBAction func addfollow(sender: UIButton) {
        
        
        ///
        let userid = Globals.user?.clnId!
        let outletid = Globals.outlet?.otlId!
        var tag = "/addfollowing?ClientId=\(userid!)&OutletId=\(outletid!)"
        if isfollow == true {
        tag = "/removefollowing?ClientId=\(userid!)&OutletId=\(outletid!)"
        
        }
        
        
        let url = Settings().mainUrl + tag
        print(url)
        
        
        
        Alamofire.request(.GET, url, parameters: ["foo": "bar"])
            .responseJSON { response in
          
                switch (response.2)
                {
                case .Success:
                    
                    
                    if let _ = response.2.value {
                       
                        self.isfollow = !self.isfollow
                        self.followBtn.selected = self.isfollow
                        let outletid = Globals.outlet?.otlId!
                        Globals.followMap[outletid!]! = self.isfollow
                        
                    }
                    break
                case .Failure:
                    
                    // print(response.2.data)
                    let result = response.2.debugDescription
                    if(result.containsString("yes"))
                    {
                        self.isfollow = !self.isfollow
                        self.followBtn.selected = self.isfollow
                        if let outletid = Globals.outlet?.otlId{
                            if  self.isfollow
                            {
                            Globals.followMap[outletid] = true
                            }
                            else{
                            
                            Globals.followMap[outletid] = false
                            }
                        }
                    }
                    if(result.containsString("The Internet connection appears to be offline"))
                    {
                        
             
                        
                        
                    }
                    
                }
                
        }
        
    }
    
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("close", object: nil)

    }
    deinit{
        NSNotificationCenter.defaultCenter().postNotificationName("close", object: nil)

    
    }
    
    
    @IBAction func back(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("close", object: nil)

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
