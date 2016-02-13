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
}

