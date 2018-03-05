/*
 Copyright (c) 2016 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Users:NSObject,NSCoding {
    public var customer_id : String?
    public var mobile_number : String?
    public var password : String?
    public var email : String?
    public var balance : String?
    public var access_token : String?
    public var member_since : String?
    public var last_activity : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    
    
    
    required public init(coder aDecoder: NSCoder) {
        customer_id = aDecoder.decodeObjectForKey("customer_id") as? String
        mobile_number = aDecoder.decodeObjectForKey("mobile_number") as? String
        password = aDecoder.decodeObjectForKey("password") as? String
        email = aDecoder.decodeObjectForKey("email") as? String
        balance = aDecoder.decodeObjectForKey("balance") as? String
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        member_since = aDecoder.decodeObjectForKey("member_since") as? String
        last_activity = aDecoder.decodeObjectForKey("last_activity") as? String
    }
    
    
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(customer_id, forKey: "customer_id")
        aCoder.encodeObject(mobile_number, forKey: "mobile_number")
        aCoder.encodeObject(password, forKey: "password")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(balance, forKey: "balance")
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(member_since, forKey: "member_since")
        aCoder.encodeObject(last_activity, forKey: "last_activity")        
    }
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Users]
    {
        var models:[Users] = []
        for item in array
        {
            models.append(Users(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Json4Swift_Base Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        customer_id = dictionary["customer_id"] as? String
        mobile_number = dictionary["mobile_number"] as? String
        password = dictionary["password"] as? String
        email = dictionary["email"] as? String
        balance = dictionary["balance"] as? String
        access_token = dictionary["access_token"] as? String
        member_since = dictionary["member_since"] as? String
        last_activity = dictionary["last_activity"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.customer_id, forKey: "customer_id")
        dictionary.setValue(self.mobile_number, forKey: "mobile_number")
        dictionary.setValue(self.password, forKey: "password")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.balance, forKey: "balance")
        dictionary.setValue(self.access_token, forKey: "access_token")
        dictionary.setValue(self.member_since, forKey: "member_since")
        dictionary.setValue(self.last_activity, forKey: "last_activity")
        
        return dictionary
    }
    
}