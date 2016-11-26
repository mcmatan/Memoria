//
//  NSDateExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 2/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func secoundsAgoFromDate(_ date : Date)->NSInteger {
        let calendar = Calendar.current
        let unitFlags = NSCalendar.Unit.second
        let earliest = (self as NSDate).earlierDate(date)
        let latest = (earliest == self) ? date : self
        let components:DateComponents = (calendar as NSCalendar).components(unitFlags, from: earliest, to: latest, options: NSCalendar.Options.wrapComponents)
        
        return components.second!
    }
    
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    
    func isInThePast()->Bool {
        return Date() > self
    }
    
    func isInTheFuture()->Bool {
        return Date() < self
    }
    
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    
    func set(minute: Int, hour: Int)->Date {
        let cal: Calendar = Calendar(identifier: .gregorian)
        let newDate: Date = cal.date(bySettingHour: hour, minute: minute, second: 0, of: self)!
        return newDate
    }
    
    func toStringWithCurrentRegion()-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-hh:mm:ss"
        formatter.locale =  Locale.current
        let formattedDateString = formatter.string(from: self)
    
        return formattedDateString
    }
    
    func toStringCurrentRegionShortTime()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.locale = Locale.current
        
        let dateString = formatter.string(from: self)
        return dateString    // "3:11 AM
    }
    
        func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
            //Declare Variables
            var isGreater = false
            
            //Compare Values
            if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
                isGreater = true
            }
            
            //Return Result
            return isGreater
        }
        
        func isLessThanDate(_ dateToCompare: Date) -> Bool {
            //Declare Variables
            var isLess = false
            
            //Compare Values
            if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
                isLess = true
            }
            
            //Return Result
            return isLess
        }
        
        func equalToDate(_ dateToCompare: Date) -> Bool {
            //Declare Variables
            var isEqualTo = false
            
            //Compare Values
            if self.compare(dateToCompare) == ComparisonResult.orderedSame {
                isEqualTo = true
            }
            
            //Return Result
            return isEqualTo
        }
        
        func addDays(_ daysToAdd: Int) -> Date {
            let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
            let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
            
            //Return Result
            return dateWithDaysAdded
        }
        
        func addHours(_ hoursToAdd: Int) -> Date {
            let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
            let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
            
            //Return Result
            return dateWithHoursAdded
        }
    
    
    func dateToDayPartDeifinisionString()->String {
        let morningStartTime = 0
        let morningEndTime = 12
        let afterNoonStartTime = 12
        let afterNoonEndTime = 18
        let eaviningStartTime = 18
        let eaviningEndTime = 25
        
        if (self.hour >= morningStartTime && self.hour <= morningEndTime) {
            return Content.getContent(ContentType.labelTxt, name: "TimeOfDayMorining")
        }
        if (self.hour >= afterNoonStartTime && self.hour <= afterNoonEndTime) {
            return Content.getContent(ContentType.labelTxt, name: "TimeOfDayAfterNoon")
        }
        if (self.hour >= eaviningStartTime && self.hour <= eaviningEndTime) {
            return Content.getContent(ContentType.labelTxt, name: "TimeOfDayEavning")
        }
        
        return "There is no time definision"
    }
    
    func hoursIntillDateDescription(date: Date)->String {
        let hoursToTask = date.hoursFrom(self)
        if hoursToTask >= 1 {
            return "In \(hoursToTask) hours"
        } else {
            let minutesTo = date.minutesFrom(self)
            return "In \(minutesTo) minutes"
        }
    }
}

