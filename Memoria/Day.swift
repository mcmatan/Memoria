//
//  Day.swift
//  Memoria
//
//  Created by Matan Cohen on 23/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

enum Day: Int {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    static func all()->[Day] {
        return [Day.sunday,
                Day.monday,
                Day.tuesday,
                Day.wednesday,
                Day.thursday,
                Day.friday,
                Day.saturday]
    }
    
    func string()->String {
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
    
    static func allStringValues()->[String] {
        return [Day.sunday.string(),
                Day.monday.string(),
                Day.tuesday.string(),
                Day.wednesday.string(),
                Day.thursday.string(),
                Day.friday.string(),
                Day.saturday.string()]
    }
}
