//
//  EventsViewController.swift
//  Mawasim
//
//  Created by Nour  on 8/1/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import Material

class EventsViewController: UIViewController{
    
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        
    }
    func load()
    {
    
    }
    
    
    func loaddatat()
    {
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventsViewController.load),name:"load", object: nil)
  
        
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    

    
}
