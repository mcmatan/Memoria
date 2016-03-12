//
//  NSDateExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 2/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    
    func secoundsAgoFromDate(date : NSDate)->NSInteger {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.Second
        let earliest = self.earlierDate(date)
        let latest = (earliest == self) ? date : self
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: NSCalendarOptions.WrapComponents)
        
        return components.second
    }
    
    func toStringWithCurrentRegion()-> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd-hh:mm:ss"
        formatter.locale =  NSLocale.currentLocale()
        let formattedDateString = formatter.stringFromDate(self)
    
        return formattedDateString
    }
    
    func toStringCurrentRegionShortTime()->String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.AMSymbol = "AM"
        formatter.PMSymbol = "PM"
        formatter.locale = NSLocale.currentLocale()
        
        let dateString = formatter.stringFromDate(NSDate())
        return dateString    // "3:11 AM
    }
    
        func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
            //Declare Variables
            var isGreater = false
            
            //Compare Values
            if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
                isGreater = true
            }
            
            //Return Result
            return isGreater
        }
        
        func isLessThanDate(dateToCompare: NSDate) -> Bool {
            //Declare Variables
            var isLess = false
            
            //Compare Values
            if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
                isLess = true
            }
            
            //Return Result
            return isLess
        }
        
        func equalToDate(dateToCompare: NSDate) -> Bool {
            //Declare Variables
            var isEqualTo = false
            
            //Compare Values
            if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
                isEqualTo = true
            }
            
            //Return Result
            return isEqualTo
        }
        
        func addDays(daysToAdd: Int) -> NSDate {
            let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
            let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
            
            //Return Result
            return dateWithDaysAdded
        }
        
        func addHours(hoursToAdd: Int) -> NSDate {
            let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
            let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
            
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
            return "morning"
        }
        if (self.hour >= afterNoonStartTime && self.hour <= afterNoonEndTime) {
            return "afternoon"
        }
        if (self.hour >= eaviningStartTime && self.hour <= eaviningEndTime) {
            return "eavning"
        }
        
        return "There is no time definision"
    }
}

