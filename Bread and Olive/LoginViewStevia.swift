

import Foundation
import UIKit
import SteviaLayout
import Material


class LoginViewStevia:UIView ,UITextFieldDelegate{
    
    var ratio = 0.552
    
    var email:ErrorTextField! = nil
    var password:TextField! = nil
    let login = RaisedButton()
    let logo = UIImageView()
    let welcome = UILabel()
    let forgetpass = UIButton()
    let signUp = UIButton()
    let donthaveAcount = UILabel()
    let background = UIImageView()
    let contentView = UIView()
    let facebook = FlatButton()//FBSDKLoginButton()
    let or = UILabel()
    let cancel = UIButton()
    var lineView:UIView!
    var lineView2:UIView!
    
    convenience init(ratio:Double) {
        self.init(frame:CGRectZero)
        self.ratio = ratio
        render()
        
    }
    
    func render()
    {
        email = ErrorTextField()
        password = TextField()
        //  backgroundColor = UIColor.whiteColor()
        let Lineleft:CGFloat = CGFloat(117 * ratio)
        let Linetop:CGFloat = CGFloat(1025 * ratio)
        let LineWidth:CGFloat = CGFloat(218 * ratio)
        let LineHeight:CGFloat = CGFloat(5 * ratio)
        
        lineView = UIView(frame: CGRect(x: Lineleft,y: Linetop,width: LineWidth,height: LineHeight))
        lineView2 = UIView(frame: CGRect(x: Lineleft + LineWidth + CGFloat(50 * ratio) + 20  ,y: Linetop,width: LineWidth,height: LineHeight))
        
        
        
        
        sv(
            contentView.style(viewStyle).sv(
                //    cancel.style(buttonStyle),
                logo.image("logo4.png").style(imageStyle),
                //  welcome.text("MAWASIM").style(labelStyle),
                email.placeholder("Email").style(fieldStyle), //.style(emailFieldStyle),
                password.placeholder("Password").style(fieldStyle).style(passwordFieldStyle),
                forgetpass.text("Forget password?").style(buttonstyle2),
                login.text("Login").style(buttonStyle),
                donthaveAcount.text("Don't have an account?").style(labelStyle2),
                signUp.text("Sign Up").style(buttonstyle2)
                //   background.image("cool.jpg").style(imageStyle2)
            )
            
        )
        
        let calcelleft:CGFloat = CGFloat(30 * ratio)
        let canceltop:CGFloat = CGFloat(50 * ratio)
        let cancelWidth:CGFloat = CGFloat(100 * ratio)
        let cancelHeight:CGFloat = CGFloat(100 * ratio)
        
        
        let logoleft:CGFloat = CGFloat(300 * ratio)
        let logotop:CGFloat = CGFloat(208.7 * ratio)
        let logoWidth:CGFloat = CGFloat(150 * ratio)
        let logoHeight:CGFloat = CGFloat(150 * ratio)
        
        let welcomeleft:CGFloat = CGFloat(233 * ratio)
        let welcometop:CGFloat = CGFloat(400 * ratio)
        let welcomeWidth:CGFloat = CGFloat(284 * ratio)
        let welcomeHeight:CGFloat = CGFloat(58 * ratio)
        
        let emailleft:CGFloat = CGFloat(87 * ratio)
        let emailtop:CGFloat = CGFloat(472 * ratio)
        let emailWidth:CGFloat = CGFloat(576 * ratio)
        let emailHeight:CGFloat = CGFloat(100 * ratio)
        
        
        let passleft:CGFloat = CGFloat(87 * ratio)
        let passtop:CGFloat = CGFloat(640 * ratio)
        let passWidth:CGFloat = CGFloat(576 * ratio)
        let passHeight:CGFloat = CGFloat(100 * ratio)
        
        
        let loginleft:CGFloat = CGFloat(87 * ratio)
        let logintop:CGFloat = CGFloat(875 * ratio)
        let loginWidth:CGFloat = CGFloat(576 * ratio)
        let loginHeight:CGFloat = CGFloat(100 * ratio)
        
        
        let forgetleft:CGFloat = CGFloat(464 * ratio)
        let forgettop:CGFloat = CGFloat(770 * ratio)
        let forgetWidth:CGFloat = CGFloat(199 * ratio)
        let forgetHeight:CGFloat = CGFloat(30 * ratio)
        
        
        
        let acountleft:CGFloat = CGFloat(87 * ratio)
        let acounttop:CGFloat = CGFloat(1100 * ratio)
        let acountWidth:CGFloat = CGFloat(350 * ratio)
        let acountHeight:CGFloat = CGFloat(57 * ratio)
        
        let signUpleft:CGFloat = CGFloat(370 * ratio)
        let signUptop:CGFloat = CGFloat(1100 * ratio)
        let signUpWidth:CGFloat = CGFloat(276 * ratio)
        let signUpHeight:CGFloat = CGFloat(57 * ratio)
        

        //  contentView.centerInContainer()
        
        layout(
            -60,
            |contentView|,
            0
        )

        
        cancel.left(calcelleft).top(canceltop).width(cancelWidth).height(cancelHeight)
        logo.left(logoleft).top(logotop).width(logoWidth).height(logoHeight)
        welcome.left(welcomeleft).top(welcometop).width(welcomeWidth).height(welcomeHeight)
        email.left(emailleft).top(emailtop).width(emailWidth).height(emailHeight)
        password.left(passleft).top(passtop).width(passWidth).height(passHeight)
        forgetpass.left(forgetleft).top(forgettop).width(forgetWidth).height(forgetHeight)
        login.left(loginleft).top(logintop).width(loginWidth).height(loginHeight)
        
        donthaveAcount.left(acountleft).top(acounttop).width(acountWidth).height(acountHeight)
        signUp.left(signUpleft).top(signUptop).width(signUpWidth).height(signUpHeight)
    }
    
    func labelStyle(f:UILabel)
    {
        if(f.text == "or")
        {
            f.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        }
        else
        {
            f.font = UIFont(name: "HelveticaNeue-Light", size: 32)
        }
        f.textAlignment = .Center
        f.textColor = MaterialColor.white
    }
    
    func labelStyle2(f:UILabel)
    {
        f.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        f.textAlignment = .Center
        f.textColor = MaterialColor.black
    }
    
    func fieldStyle(f:TextField) {
        f.borderStyle = .RoundedRect
        f.autocorrectionType = .No
        f.autocapitalizationType = .None
        f.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        f.returnKeyType = .Next
        //    email = ErrorTextField(frame: CGRectMake(40, 120, self.bounds.width - 80, 32))
        
        //  f.detail = "Error, incorrect email"
        f.enableClearIconButton = true
        f.delegate = self
        
        f.placeholderColor = MaterialColor.blue.base
        f.placeholderActiveColor = MaterialColor.deepPurple.base
        f.dividerColor = MaterialColor.pink.base
        f.textColor = MaterialColor.black
        f.backgroundColor = UIColor.clearColor()
        f.font = MaterialFont.systemFontWithSize(12)
        
    }
    
    func passwordFieldStyle(f:UITextField) {
        f.secureTextEntry = true
        f.returnKeyType = .Done
    }

    
    
    
    func buttonStyle(b:UIButton) {
        
        if(b.titleLabel?.text == "Login")
        {
            // b.backgroundColor = UIColor.init(colorLiteralRed: 18 / 255, green: 151 / 255, blue: 147 / 255 ,alpha: 1)
            b.backgroundColor = MaterialColor.pink.darken1
            b.alpha = 0.8
        }
        if(b.titleLabel?.text == "Facebook")
        {
            
            b.backgroundColor = MaterialColor.blue.darken4
            b.alpha = 0.8
        }
        
        //    b.setImage(UIImage(named:"cm_arrow_back_white"), forState: UIControlState.Normal)
        b.layer.cornerRadius = 10
        // b.layer.cornerRadius = 8.0
        b.layer.masksToBounds = false
        //b.layer.borderWidth = 1.0
        
        
        
    }
    
    
    
    func imageStyle2(b:UIImageView) {
        
        b.contentMode = .ScaleToFill
        
    }
    
    
    
    func imageStyle(b:UIImageView) {
        //b.backgroundColor = UIColor.init(colorLiteralRed: 18 / 255, green: 151 / 255, blue: 147 / 255 ,alpha: 1)
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
        if(f.titleLabel?.text == "Sign Up")
        {
            f.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        }
        else
        {
            f.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 10)
            
        }
        f.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
    }
    
    func viewStyle(v:UIView)
    {
        v.layer.cornerRadius = 3
        v.backgroundColor = MaterialColor.clear
        
        
    }
    
    
    
}