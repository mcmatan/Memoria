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
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        formatter.locale =  NSLocale.currentLocale()
        let formattedDateString = formatter.stringFromDate(self)
    
        return formattedDateString
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
}

