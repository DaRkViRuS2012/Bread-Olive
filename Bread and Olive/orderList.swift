/*
 Copyright (c) 2016 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class orderList {
    public var order_id : String?
    public var restaurant_name : String?
    public var date_time : String?
    public var sum : String?
    public var tax : String?
    public var discount : String?
    public var total : String?
    public var comments : String?
    public var status : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Json4Swift_Base Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [orderList]
    {
        var models:[orderList] = []
        for item in array
        {
            models.append(orderList(dictionary: item as! NSDictionary)!)
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
        
        order_id = dictionary["order_id"] as? String
        restaurant_name = dictionary["restaurant_name"] as? String
        date_time = dictionary["date_time"] as? String
        sum = dictionary["sum"] as? String
        tax = dictionary["tax"] as? String
        discount = dictionary["discount"] as? String
        total = dictionary["total"] as? String
        comments = dictionary["comments"] as? String
        status = dictionary["status"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.order_id, forKey: "order_id")
        dictionary.setValue(self.restaurant_name, forKey: "restaurant_name")
        dictionary.setValue(self.date_time, forKey: "date_time")
        dictionary.setValue(self.sum, forKey: "sum")
        dictionary.setValue(self.tax, forKey: "tax")
        dictionary.setValue(self.discount, forKey: "discount")
        dictionary.setValue(self.total, forKey: "total")
        dictionary.setValue(self.comments, forKey: "comments")
        dictionary.setValue(self.status, forKey: "status")
        
        return dictionary
    }
    
}