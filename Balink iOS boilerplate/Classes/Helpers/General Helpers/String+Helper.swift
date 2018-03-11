//
//  String+Helper.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
extension String {
    var unCapitalizeFirstLetter: String {
        get {
            let first = String(characters.prefix(1)).lowercased()
            let other = String(characters.dropFirst())
            return first + other
        }
    }
    var capitalizeFirstLetter: String {
        get {
            let first = String(characters.prefix(1)).uppercased()
            let other = String(characters.dropFirst())
            return first + other
        }
    }
    
    var length: Int {
        get {
            return characters.count
        }
    }
    
    func fromSfDatetime()->NSDate?{
        let formater = DateFormatter()
        formater.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'+0000'" //2017-01-29T15:00:00.000+0000
        
        return formater.date(from: self) as NSDate?
        
    }
    
    func fromSfDate(forceUTCTimeZone: Bool = false)->Date?{
        let formater = DateFormatter()
        if forceUTCTimeZone {
            formater.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        }
        formater.dateFormat = "yyyy-MM-dd" //2017-01-29
        
        return formater.date(from: self) as Date?
        
    }
    
    func stringfromDate(date:NSDate)->String?{
        let formater = DateFormatter()
        formater.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        formater.dateFormat = "yyyy-MM-dd" //2017-01-29
        
        return formater.string(from: date as Date)
        
    }
    
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$", options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
        } catch { return false }
    }
}
