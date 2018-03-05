//
//  Globals.swift
//  Bread and olive
//
//  Created by Nour  on 8/18/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import Foundation


class Globals{
    
    static var res:Restaurants!
    static var user:Users!
    static var islogedin = false
    static var serverKey = "AIzaSyAuifcayIij-vj0o0eTn6sO-S18WVJ5kdY"
    static var Basket:[Meals]=[Meals]()
    static var isPushed = false
    
    static func find(items:[Meals],item:Meals) -> Int{
        
        for i in 0 ..< items.count {
            if ((items[i].meal_id) == item.meal_id){
                
                return i
            }
        }
        return -1
    }

    
    static var favRes:Dictionary<String,Bool> = Dictionary<String,Bool>()
    static var favMeal:Dictionary<String,Bool> = Dictionary<String,Bool>()
    
}