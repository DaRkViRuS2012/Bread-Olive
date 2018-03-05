/* 
Copyright (c) 2016 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Restaurants {
	public var restaurant_id : String?
	public var restaurant_name : String?
	public var phone : String?
	public var logo_url : String?
    public var time_open : String?
    public var time_close : String?
    public var longitude : String?
    public var latitude : String?
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let restaurants_list = Restaurants.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Restaurants Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Restaurants]
    {
        var models:[Restaurants] = []
        for item in array
        {
            models.append(Restaurants(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let restaurants = Restaurants(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Restaurants Instance.
*/
	required public init?(dictionary: NSDictionary) {

		restaurant_id = dictionary["restaurant_id"] as? String
		restaurant_name = dictionary["restaurant_name"] as? String
		phone = dictionary["phone"] as? String
		logo_url = dictionary["logo_url"] as? String
        time_open = dictionary["time_open"] as? String
        time_close = dictionary["time_close"] as? String
        longitude = dictionary["longitude"] as? String
        latitude = dictionary["latitude"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.restaurant_id, forKey: "restaurant_id")
		dictionary.setValue(self.restaurant_name, forKey: "restaurant_name")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.logo_url, forKey: "logo_url")
        dictionary.setValue(self.time_open, forKey: "time_open")
        dictionary.setValue(self.time_close, forKey: "time_close")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        return dictionary
	}

}