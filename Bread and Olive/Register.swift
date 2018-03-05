//
//  LoginView.swift
//  DemoExpandingCollection
//
//  Created by Nour  on 6/20/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import Foundation
import UIKit
import SteviaLayout
import Material


class Register:UIView,UITextFieldDelegate {
    
    var ratio = 0.552
    var firstname :ErrorTextField! = nil
  //  var lastName :ErrorTextField! = nil
    var email :ErrorTextField! = nil
    var password:ErrorTextField! = nil
    var confirm:ErrorTextField! = nil
    let login = RaisedButton()
    let creataccount = UILabel()
    let contentView = UIView()
    let haveacount = UIButton()
    
    convenience init(ratio:Double) {
        self.init(frame:CGRectZero)
        self.ratio = ratio
        render()
        
    }
    
    func render()
    {
        
        firstname = ErrorTextField()
        password = ErrorTextField()
        confirm = ErrorTextField()
        email = ErrorTextField()
        firstname.tag = 1
       confirm.tag = 2
        email.tag = 3
        password.tag = 4
        
        backgroundColor = UIColor.grayColor()
        
        sv(
            contentView.style(viewStyle).sv(
                //creataccount.text("CREATE NEW\n ACCOUNT").style(labelStyle),
                firstname.placeholder("Email").style(fieldStyle),
            //    lastName.placeholder("Last Name").style(fieldStyle),
                email.placeholder("Mobile").style(fieldStyle), //.style(emailFieldStyle),
                password.placeholder("Password").style(fieldStyle).style(passwordFieldStyle),
                confirm.placeholder("Confirm").style(fieldStyle).style(passwordFieldStyle),
                login.text("CREATE NEW ACCOUNT").style(buttonStyle)
           //     haveacount.text("already have an account?").style(buttonstyle2)
            )
        )
        
        let welcomeleft:CGFloat = CGFloat(246 * ratio)
        let welcometop:CGFloat = CGFloat(200 * ratio)
        let welcomeWidth:CGFloat = CGFloat(258 * ratio)
        let welcomeHeight:CGFloat = CGFloat(76 * ratio)
        
        
        let firstnameleft:CGFloat = CGFloat(87 * ratio)
        let firstnametop:CGFloat = CGFloat(200 * ratio)
        let firstnameHeight:CGFloat = CGFloat(100 * ratio)
        
        

        
        let emailleft:CGFloat = CGFloat(87 * ratio)
        let emailtop:CGFloat = CGFloat(357 * ratio)
        let emailWidth:CGFloat = CGFloat(576 * ratio)
        let emailHeight:CGFloat = CGFloat(100 * ratio)
        
        
        let passleft:CGFloat = CGFloat(87 * ratio)
        let passtop:CGFloat = CGFloat(510 * ratio)
        let passWidth:CGFloat = CGFloat(576 * ratio)
        let passHeight:CGFloat = CGFloat(100 * ratio)
        
        let confirmleft:CGFloat = CGFloat(87 * ratio)
        let confirmtop:CGFloat = CGFloat(663 * ratio)
        let confirmWidth:CGFloat = CGFloat(576 * ratio)
        let confirmHeight:CGFloat = CGFloat(100 * ratio)
        
        
        let loginleft:CGFloat = CGFloat(87 * ratio)
        let logintop:CGFloat = CGFloat(950 * ratio)
        let loginWidth:CGFloat = CGFloat(576 * ratio)
        let loginHeight:CGFloat = CGFloat(100 * ratio)
        
        
    
        
      //  contentView.centerInContainer()
        
        layout(
            0,
            |contentView|,
            0
        )
        
        
        
        firstname.left(firstnameleft).top(firstnametop).width(emailWidth).height(firstnameHeight)
      //  lastName.left(lastnameleft).top(lastnametop).width(lastnameWidth).height(lastnameHeight)
        creataccount.left(welcomeleft).top(welcometop).width(welcomeWidth).height(welcomeHeight)
        email.left(emailleft).top(emailtop).width(emailWidth).height(emailHeight)
        password.left(passleft).top(passtop).width(passWidth).height(passHeight)
        login.left(loginleft).top(logintop).width(loginWidth).height(loginHeight)
        confirm.left(confirmleft).top(confirmtop).width(confirmWidth).height(confirmHeight)
    }
    
    func labelStyle(f:UILabel)
    {
        f.font = MaterialFont.systemFontWithSize(13)
        f.textAlignment = .Center
        f.numberOfLines = 2
        f.textColor = MaterialColor.white
    }
    func fieldStyle(f:ErrorTextField) {
        f.borderStyle = .RoundedRect
        f.autocorrectionType = .No
        f.autocapitalizationType = .None
        f.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        f.returnKeyType = .Next
        //    email = ErrorTextField(frame: CGRectMake(40, 120, self.bounds.width - 80, 32))
        if(f.tag == 1)
        {
        
         f.detail = "Error, enter a correrct email"
           
        }
        if(f.tag == 2)
        {
            
            
            f.detail = "Password don't much"

            
        }
        
        if(f.tag == 3)
        {
            
        f.detail = "Error, incorrect mobile"
            
        }
        
        if(f.tag == 4)
        {
            
        f.detail = "Error, this field can't be empty"
            
        }
        f.enableClearIconButton = true
        f.delegate = self
        f.placeholderColor = MaterialColor.blue.base
        f.placeholderActiveColor = MaterialColor.deepPurple.base
        f.dividerColor = MaterialColor.pink.base
        f.textColor = MaterialColor.white
        f.backgroundColor = UIColor.clearColor()
        f.font = MaterialFont.systemFontWithSize(12)
        
    }
    
    func passwordFieldStyle(f:UITextField) {
        f.secureTextEntry = true
        f.returnKeyType = .Done
    }
    
    func buttonStyle(b:UIButton) {
        b.backgroundColor = UIColor.init(colorLiteralRed: 18 / 255, green: 151 / 255, blue: 147 / 255 ,alpha: 1)
        b.layer.cornerRadius = 10
        // b.layer.cornerRadius = 8.0
        b.layer.masksToBounds = false
        //b.layer.borderWidth = 1.0
        
        b.layer.shadowColor = UIColor.grayColor().CGColor;
        b.layer.shadowOpacity = 0.8;
        b.layer.shadowRadius = 10;
        b.layer.shadowOffset = CGSizeMake(10, 10);
        
        
    }
    
    func buttonstyle2(f:UIButton)
    {
        f.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        f.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
    }
    
    func viewStyle(v:UIView)
    {
        v.layer.cornerRadius = 3
        v.backgroundColor = MaterialColor.darkText.secondary
        
        
        
    }
    
    
    
}