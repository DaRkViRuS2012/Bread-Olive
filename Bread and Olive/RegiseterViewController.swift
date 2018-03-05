//
//  ViewController.swift
//  DemoExpandingCollection
//
//  Created by Nour  on 6/20/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import SwiftyJSON
import Material
class RegisterViewController: UIViewController {
    
    var register:Register!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.load()
        on("INJECTION_BUNDLE_NOTIFICATION") {
            self.load()
        }
        
        
    }
    
    private func prepareNavigationItem() {
        navigationItem.title = "Register"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
    
    }

    
    func handelback(){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func load(){
        
        

        
        
        prepareNavigationItem()
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "register.jpg")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        
        
        let ratio = Double(self.view.frame.width / 750)
        register = Register(ratio: ratio)
      //  register.haveacount.tap(login)
        register.login.tap(createaccount)
        
        self.view = register
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard)))
        
        
        register.email.addTarget(self, action: #selector(RegisterViewController.textFieldDidBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        register.email.addTarget(self, action: #selector(RegisterViewController.textFieldDidEndEditing(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        register.password.addTarget(self, action: #selector(RegisterViewController.textFieldDidBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        register.password.addTarget(self, action: #selector(RegisterViewController.textFieldDidEndEditing(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        register.firstname.addTarget(self, action: #selector(RegisterViewController.textFieldDidEndEditing(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        register.firstname.addTarget(self, action: #selector(RegisterViewController.textFieldDidBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        //  register.lastName.addTarget(self, action: #selector(RegisterViewController.textFieldDidBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        //register.lastName.addTarget(self, action: #selector(RegisterViewController.textFieldDidEndEditing(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    
    
    func createaccount(){
        let email = register.firstname.text?.trim()
        let mobile = register.email.text?.trim()
        let password = register.password.text!.sha1()
        let confirm = register.confirm.text
        register.firstname.revealError = false
        register.email.revealError = false
        register.password.revealError = false
        register.confirm.revealError = false
        if((isValidEmail(email!) == true) && (isvaildUser(password) == true )&&(validatePhone(mobile!) == true)&&(vaildConfirm(confirm!) == true))
        {
        
    
            let url = Settings.mainUrl + "register"
            print(url)
            
            let ur = url.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            
            
            let parameter:[String:AnyObject] = ["email":email!,"password":password,"mobile":mobile!]
            Alamofire.request(.POST, ur!,parameters: parameter)
                .responseJSON { response in
              print(response.2.debugDescription)
                    switch (response.2)
                    {
                    case .Success:
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            showCloseButton: false
                        )
                      
                        let alert = SCLAlertView(appearance: appearance)
                     
                        
                        alert.addButton("Done", action: {
                        

                       
                     
                        if let value = response.2.value {
                            let json = JSON(value)
                         //   let user = User.modelsFromDictionaryArray(json.rawValue as! NSArray)
                          //  Globals.islogedin = true
                            //Globals.user = user[0]
                            
                            if Globals.isPushed == true {
                              self.dismissViewControllerAnimated(true, completion: nil)
                                
                            }
                            
                            
                            let bottomNavigationController: RecipesViewController = RecipesViewController()
                            let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
                            let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
                            UIApplication.sharedApplication().keyWindow?.rootViewController = navigationDrawerController

                            print("JSON: \(json)")
                            }
                        })
                        
                         alert.showSuccess("Congratulations", subTitle: "successfully Register.", closeButtonTitle: "Done", duration: 0.0, colorStyle: 0xA429FF, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: "ic_check_white")?.imageWithRenderingMode(.AlwaysOriginal), animationStyle: .TopToBottom)
                        
                        break
                    case .Failure:
                        
                    
                        let result = response.2.debugDescription
                        if(result.containsString("already found"))
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
                                subTitle: "email is already found!", // String of view
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
        
        
        if(isValidEmail(email!) == false)
        {
            register.firstname.revealError = true
        }
        if(validatePhone(mobile!) == false)
        {
            
            register.email.revealError = true
        }
        
        if(vaildConfirm(confirm!) == false)
        {
            
            register.confirm.revealError = true
        }

        
        if(isvaildUser(password) == false)
        {
            
            register.password.revealError = true
        }
    }
    
    
    func login()
    {
        print("nour")
        
        self.performSegueWithIdentifier("LoginSegue", sender: nil)
        
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(sender:UITextField)
    {
        
        animateViewMoving(true, moveValue: 100)
    }
    
    
    func textFieldDidEndEditing(sender: AnyObject) {
        
        animateViewMoving(false, moveValue: 100)
    }
    
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
  
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    func isvaildUser(name:String)-> Bool{
        
        let count =  name.characters.count
        if( count > 0 )
        {
            return true
        }
        return false
    }
    
    
    func vaildConfirm(value:String) ->Bool
    {
    
    let pass = register.password.text
        if pass != value{
        
        return false
        }
        return true
    
    }
    
    
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
}
