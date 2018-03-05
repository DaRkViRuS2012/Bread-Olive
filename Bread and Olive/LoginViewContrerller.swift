

import UIKit
import SCLAlertView
import Alamofire
import FFJLoadButton
import SwiftyJSON
import Material
class LoginViewController: UIViewController {
    
    
    
    private var menuButton: IconButton!
    
    /// NavigationBar switch control.
    private var switchControl: MaterialSwitch!
    
    /// NavigationBar search button.
    private var searchButton: IconButton!

    
    
    //  let ratio = Double(self.view.frame.width / 750)
    var login:LoginViewStevia!
    var register:Register!
    static var isfromMain = true
    
    let userDefulat = NSUserDefaults.standardUserDefaults()
    
    
    
    
    func prepareView() {
       // view.backgroundColor = MaterialColor.white
        prepareMenuButton()
        prepareNavigationItem()
        
    }
    
    /// Handles the menuButton.
    internal func handleMenuButton() {
        navigationDrawerController?.openLeftView()
    }
    
    /// Handles the searchButton.
    
    /// Prepares the menuButton.
    private func prepareMenuButton() {
        let image: UIImage? = UIImage(named: "cm_menu_white")
        menuButton = IconButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        menuButton.addTarget(self, action: #selector(handleMenuButton), forControlEvents: .TouchUpInside)
    }
    

    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Sign In"
        navigationItem.titleLabel.textAlignment = .Left
        navigationItem.titleLabel.textColor = MaterialColor.white
        navigationItem.titleLabel.font = RobotoFont.mediumWithSize(20)
        
        navigationItem.leftControls = [menuButton]
     //   navigationItem.rightControls = [switchControl, searchButton]
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.load()
        self.prepareView()
        on("INJECTION_BUNDLE_NOTIFICATION") {
            self.load()
        }
        
    }
    
    

    

    
    
    func load()
    {
        
        
 
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "login.jpg")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        let ratio = Double(self.view.frame.height / 1334)
        
        
        login = LoginViewStevia(ratio: ratio)
        register = Register(ratio: ratio)
      
        login.signUp.tap(createaccount)
        login.login.tap(Login)
    
        self.view = login
        login.forgetpass.addTarget(self, action: #selector(LoginViewController.forgetPass), forControlEvents: UIControlEvents.TouchUpInside)
        
        login.email.addTarget(self, action: #selector(LoginViewController.textFieldDidBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        login.email.addTarget(self, action: #selector(LoginViewController.textFieldDidEndEditing(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        login.password.addTarget(self, action: #selector(LoginViewController.textFieldDidBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        login.password.addTarget(self, action: #selector(LoginViewController.textFieldDidEndEditing(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard)))
        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    func forgetPass()
    {
        self.performSegueWithIdentifier("forgetSegue", sender: nil)
        
    }
    
    
    func createaccount()
    {
        
   //     self.performSegueWithIdentifier("RegisterSegue", sender: nil)
     self.navigationController?.pushViewController(RegisterViewController(), animated: true)
        
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    
    func Login()
    {
        
        
        let email = login.email.text?.trim()
        let pass = login.password.text!.sha1()
        print("pass\(pass)")
        if(email!.characters.count>0&&pass.characters.count>0)
        {
            let url = Settings.mainUrl + "login"//?email=\(email!)&password=\(pass!.sha1())"
            print(url)
            
            let url1 = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let parameter:[String:AnyObject] = ["email":email!,"password":pass]
                Alamofire.request(.POST, url1,parameters: parameter)
                .responseJSON { response in
                    print(response)
                    print(response.0)
                    print(response.1)
                    print(response.2.debugDescription)
                    print(response.2.description)
                    
                    switch (response.2)
                    {
                    case .Success:
                        
                        
                        
                        
                        if let value = response.2.value {
                            let json = JSON(value)
                            
                           
                        
                            if json.rawString() == "false"
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
                                    subTitle: "User name or password are incorrect !", // String of view
                                    duration: 2.0, // Duration to show before closing automatically, default: 0.0
                                    completeText: "Try again", // Optional button value, default: ""
                                    style: SCLAlertViewStyle.Error, // Styles - see below.
                                    colorStyle: 0xA429FF,
                                    colorTextButton: 0xFFFFFF
                                )
                                
                            }
                            else
                            {
                        
                                let user = Users.modelsFromDictionaryArray(json.rawValue as! NSArray)
                                Globals.user = user[0]
                                
                                
                                print("JSON: \(json)")
                                Globals.islogedin = true
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 16)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 12)!,
                            showCloseButton: false
                        )
                        
                        let alert = SCLAlertView(appearance: appearance)
                        
                        
                        alert.addButton("Done", action: {
                            if Globals.isPushed == true {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        
                            
                            let bottomNavigationController: RecipesViewController = RecipesViewController()
                            let navigationController: AppNavigationController = AppNavigationController(rootViewController: bottomNavigationController)
                            let navigationDrawerController: AppNavigationDrawerController = AppNavigationDrawerController(rootViewController: navigationController, leftViewController: AppLeftViewController())
                            UIApplication.sharedApplication().keyWindow?.rootViewController = navigationDrawerController
                            

                        })
                        
                        alert.showSuccess("Congratulations", subTitle: "successfully Loged in.", closeButtonTitle: "Done", duration: 0.0, colorStyle: 0xA429FF, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: "ic_check_white")?.imageWithRenderingMode(.AlwaysOriginal), animationStyle: .TopToBottom)
                        
                        
                        
                        
                        }
                        }
                        break
                    case .Failure:
                        
                        // print(response.2.data)
                        let result = response.2.debugDescription
                        if(result.containsString("no row"))
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
        else{
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 16)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 12)!,
                showCloseButton: true
            )
            
            let alert = SCLAlertView(appearance: appearance)
            
            
            alert.showTitle(
                "", // Title of view
                subTitle: "Please enter your email and password .", // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Try again!", // Optional button value, default: ""
                style: SCLAlertViewStyle.Error, // Styles - see below.
                colorStyle: 0xA429FF,
                colorTextButton: 0xFFFFFF
            )
            
        }
        
        
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
    
    
    func back()
    {
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
}



class FBUSER :NSObject{
    
    var name:String?
    var email:String?
    var profilePicture:String!
    
    
    
}


