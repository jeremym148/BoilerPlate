//
//  Date+Format.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import Foundation
extension Date {
    static func from(day:String?, month:String?, year:String?) -> Date?{
        if let day = day, let month = month, let year = year, !day.isEmpty, !month.isEmpty, !year.isEmpty{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            return dateFormatter.date(from: "\(month)-\(day)-\(year)")!
        }
        else{
            return nil
        }
    }
    
    static func getMonday(_ myDate: Date? = nil) -> Date {
        let today = myDate != nil ? myDate : Date()
        let cal = Calendar.current
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: today!)
        comps.weekday = 2 // Monday
        let mondayInWeek = cal.date(from: comps)!
        return mondayInWeek
    }
   
    
    static func getWeekdays(by date: Date? = nil) -> [Date]{
        let today = getMonday(date)
        var days = [Date]()
        for i in 0 ... 6 {
            let day = Calendar.current.date(byAdding: .day, value: i, to: today)!
            days.append(day)
        }
        return(days)
    }
    
    func shortDateFormat()->String{
        return formatDate(date: self as Date, format: "dd.MM.yyyy")
    }
    
    func monthYearFormat() -> String {
        return formatDate(date: self as Date, format: "MMM yyyy")
    }
    
    func dayMonthPlainFormat() -> String {
        return formatDate(date: self as Date, format: "MMM dd")
    }
    
    func dayString() -> String {
        return formatDate(date: self as Date, format: "d")
    }
    
    func dayMonthYearPlainFormat() -> String {
        return formatDate(date: self as Date, format: "MMM dd, yyyy")
    }
    
    func toSfDate() -> String {
        return formatDate(date: self as Date, format: "yyyy-MM-dd")
    }
    
    func toSfDateTime() -> String {
        return formatDate(date: self as Date, format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'")
    }
    
    func addDays(numOfDay: Int) -> Date?{
        return Calendar.current.date(byAdding: .day, value: numOfDay, to: self as Date) as Date?
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
    
    func shortDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self as Date)
    }
    
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self as Date)
    }
    
    func toAMPMTime() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self as Date)
    }
    
    func getDuration(from startDate: Date) ->DateComponents{
        let calendar = NSCalendar.current
        return calendar.dateComponents([.hour,.minute], from: startDate, to: self)
    }
    
    func startOfDay() -> Date {
        return NSCalendar.current.startOfDay(for: self)
    }
    
    func monthDayFormat() -> String {
        return formatDate(date: self, format: "MMMM dd")
    }
    
    func getDaysDifference(date: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: date.startOfDay(), to: self.startOfDay())
        return components.day!
    }
    
    func inPast() -> Bool{
        return getDaysDifference(date: Date()) < 0
    }
    
    func isToday() -> Bool{
        return Calendar.current.isDate(self, inSameDayAs:Date())
    }
    
    static func stringToDate(stringDate:String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: stringDate)
    }
    
    func isInLastNDays(ndays:Int)->Bool{
        let dateReference = Date().addDays(numOfDay: -ndays)
        return self.compare(dateReference!) == ComparisonResult.orderedDescending
    }
}
