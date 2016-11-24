//
//  Day.swift
//  Memoria
//
//  Created by Matan Cohen on 23/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

enum Day: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    static func all()->[Day] {
        return [Day.sunday,
                Day.monday,
                Day.tuesday,
                Day.wednesday,
                Day.thursday,
                Day.friday,
                Day.saturday]
    }
    
    func stringShort()->String {
        switch self {
        case .sunday:
            return "S"
        case .monday:
            return "M"
        case .tuesday:
            return "T"
        case .wednesday:
            return "W"
        case .thursday:
            return "T"
        case .friday:
            return "F"
        case .saturday:
            return "S"
        }
    }
    
    func stringLong()->String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }
    
    static func allStringShortValues()->[String] {
        return [Day.sunday.stringShort(),
                Day.monday.stringShort(),
                Day.tuesday.stringShort(),
                Day.wednesday.stringShort(),
                Day.thursday.stringShort(),
                Day.friday.stringShort(),
                Day.saturday.stringShort()]
    }
}
