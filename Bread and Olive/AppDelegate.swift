//
//  AppDelegate.swift
//  Bread and olive
//
//  Created by Nour  on 8/5/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    let userDefulat = NSUserDefaults.standardUserDefaults()
    
    
    
    
    func loadUserData(){
        
        
        if let _ = userDefulat.objectForKey("USER"){
            let data = userDefulat.objectForKey("USER") as! NSData
            let usr = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Users
            
            Globals.islogedin = true
            Globals.user = usr
            
        }
        
    }
    
    
    
    
    func saveData(){
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        
        
        if Globals.islogedin == true {
            if let user = Globals.user {
                let NSUSER = NSKeyedArchiver.archivedDataWithRootObject(user)
                userDefulat.setObject(NSUSER, forKey: "USER")
                
            }
        }
        
        
        
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        loadUserData()
        GMSServices.provideAPIKey("AIzaSyA-mJu438bwvCSs2yCDPq4HF21GBuS7wok")
        GMSPlacesClient.provideAPIKey("AIzaSyA-mJu438bwvCSs2yCDPq4HF21GBuS7wok")
        let bottomNavigationController: RecipesViewController = RecipesViewController()
        let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
        
        let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = navigationDrawerController
        window!.makeKeyAndVisible()
        
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }
    
    
}

