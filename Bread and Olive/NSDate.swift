//
//  NSDate.swift
//  eDamus_f
//
//  Created by Nour  on 5/4/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import Foundation
extension NSDate {
    convenience init?(jsonDate: String) {
        
        let prefix = "/Date("
        let suffix = ")/"
        // Check for correct format:
        if jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) {
            // Extract the number as a string:
            let from = jsonDate.startIndex.advancedBy(prefix.characters.count)
            let to = jsonDate.endIndex.advancedBy(-suffix.characters.count)
            // Convert milleseconds to double
            guard let milliSeconds = Double(jsonDate[from ..< to]) else {
                return nil
            }
            // Create NSDate with this UNIX timestamp
            self.init(timeIntervalSince1970: milliSeconds/1000.0)
        } else {
            return nil
        }
    }
}