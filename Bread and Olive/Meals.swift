/* 
Copyright (c) 2016 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Meals {
	public var meal_id : String?
	public var price : String?
	public var restaurant_id : String?
	public var components_ids : String?
	public var components_names_ar : String?
	public var components_names_en : String?
	public var meal_name : String?
	public var type_id : String?
	public var type_name : String?
    public var string_id : String?
    public var meal_description : String?
    public var itmcnt : Int!
    public var liked : Bool!

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let meals_list = Meals.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Meals Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Meals]
    {
        var models:[Meals] = []
        for item in array
        {
            models.append(Meals(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let meals = Meals(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Meals Instance.
*/
    init(name:String,id:String,cnt:Int,prc:String){
    meal_id = id
    meal_name = name
    itmcnt = cnt
    price = prc
    }
    
	required public init?(dictionary: NSDictionary) {

		meal_id = dictionary["meal_id"] as? String
		price = dictionary["price"] as? String
		restaurant_id = dictionary["restaurant_id"] as? String
		components_ids = dictionary["components_ids"] as? String
		components_names_ar = dictionary["components_names_ar"] as? String
		components_names_en = dictionary["components_names_en"] as? String
		meal_name = dictionary["meal_name"] as? String
		type_id = dictionary["type_id"] as? String
		type_name = dictionary["type_name"] as? String
        meal_description = dictionary["meal_description"] as? String
        string_id = dictionary["string_id"] as? String
        itmcnt = 0
        let s = Globals.favMeal[meal_id!] != nil
        liked = false
        if s {
        liked = Globals.favMeal[meal_id!]
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.meal_id, forKey: "meal_id")
		dictionary.setValue(self.price, forKey: "price")
		dictionary.setValue(self.restaurant_id, forKey: "restaurant_id")
		dictionary.setValue(self.components_ids, forKey: "components_ids")
		dictionary.setValue(self.components_names_ar, forKey: "components_names_ar")
		dictionary.setValue(self.components_names_en, forKey: "components_names_en")
		dictionary.setValue(self.meal_name, forKey: "meal_name")
		dictionary.setValue(self.type_id, forKey: "type_id")
		dictionary.setValue(self.type_name, forKey: "type_name")
        dictionary.setValue(self.meal_description, forKey: "meal_description")
        dictionary.setValue(self.string_id, forKey: "string_id")
		return dictionary
	}

}