//
//  NSDate+Format.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
extension NSDate {
    
    func monthYearFormat() -> String {
        return formatDate(date: self as Date, format: "MMM yyyy")
    }
    
    func dayFormat() -> String {
        return formatDate(date: self as Date, format: "dd")
    }
    
    func dayNameFormat() -> String {
        return formatDate(date: self as Date, format: "EEEE")
    }
    
    func monthDayFormat() -> String {
        return formatDate(date: self as Date, format: "MMMM dd")
    }
    
    func toSfDate() -> String {
        return formatDate(date: self as Date, format: "yyyy-MM-dd")
    }
    
    func toDefaultFullDate() ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocalizeUtils.localizedLocal)
        dateFormatter.dateStyle = .full
        
        return dateFormatter.string(from: self as Date)
    }
    
    func toFullDate() ->String{
        return formatDate(date: self as Date, format: "EEEE, MMM dd, yyyy")
    }
    
    
    func toSfDateTime() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        //dateFormatter.timeZone = NSTimeZone.init(abbreviation: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self as Date)
    }
    
    func toAMPMTime() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self as Date)
    }
    
    func shortDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self as Date)
    }
    
    func shortDate(forceUTCTimeZone: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        if forceUTCTimeZone {
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        }
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self as Date)
    }
    
    func startOfDay() ->  NSDate {
        return NSCalendar.current.startOfDay(for: self as Date) as NSDate
    }
    
    func getDaysDifference(date: NSDate) -> Int {
        let components = Calendar.current.dateComponents([.day], from: date.startOfDay() as Date, to: self.startOfDay() as Date)
        return components.day!
    }
    
    func addDays(numOfDay: Int) -> NSDate?{
        return Calendar.current.date(byAdding: .day, value: numOfDay, to: self as Date) as NSDate?
    }
    
    
    private func formatDate(date:Date, format:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    func getDateComponents() -> (year:String,month:String,day:String)
    {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self as Date)
        let month = calendar.component(.month, from: self as Date)
        let day = calendar.component(.day, from: self as Date)
        
        return(year:String(year),month:String(month),day:String(day))
    }
}

