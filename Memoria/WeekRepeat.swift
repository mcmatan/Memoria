//
//  WeekRepeat.swift
//  Memoria
//
//  Created by Matan Cohen on 23/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

/*
 
 Task {
 RepeateOnDates {
 sunday: ["10:00", "14:00"],
 monday: ["10:00", "14:00"],
 tuesday: ["10:00", "14:00"],
 wednesday: ["10:00", "14:00"],
 thursday: ["10:00", "14:00"],
 friday: ["10:00", "14:00"],
 saturday: ["10:00", "14:00"],
 }
 
 }
 */

let timeDateFormatter = DateFormatter()

let kSunday = "sunday"
let kMonday = "monday"
let kTuesday = "tuesday"
let kWednesday = "wednesday"
let kThursday = "thursday"
let kFriday = "friday"
let kSaturday = "saturday"


class WeekRepeate {
    var week = [Day: [Time]]()

    init(dic: [String: [String]]) {
        self.week[Day.sunday] = self.getDayTimesFromDayString(day: dic[kSunday])
        self.week[Day.monday] = self.getDayTimesFromDayString(day: dic[kMonday])
        self.week[Day.tuesday] = self.getDayTimesFromDayString(day: dic[kTuesday])
        self.week[Day.wednesday] = self.getDayTimesFromDayString(day: dic[kWednesday])
        self.week[Day.thursday] = self.getDayTimesFromDayString(day: dic[kThursday])
        self.week[Day.friday] = self.getDayTimesFromDayString(day: dic[kFriday])
        self.week[Day.saturday] = self.getDayTimesFromDayString(day: dic[kSaturday])
    }
    
    init(dic: [Day: [Time]]) {
        self.week = dic
    }
    
    init(withDayAndTime: (days: [Day], times: [Time])) { // This is only for the time beeing when you are can not input diffrent times for diffrent days for the same task
        for day in withDayAndTime.days {
            switch day {
            case Day.sunday:
                self.week[Day.sunday] = withDayAndTime.times
            case Day.monday:
                self.week[Day.monday] = withDayAndTime.times
            case Day.tuesday:
                self.week[Day.tuesday] = withDayAndTime.times
            case Day.wednesday:
                self.week[Day.wednesday] = withDayAndTime.times
            case Day.thursday:
                self.week[Day.thursday] = withDayAndTime.times
            case Day.friday:
                self.week[Day.friday] = withDayAndTime.times
            case Day.saturday:
                self.week[Day.saturday] = withDayAndTime.times
            }
        }
    }
    
    init() {
        
    }
    
    func getDayTimesFromDayString(day: [String]?)->[Time] {
        var allTimes = [Time]()
        
        guard let isDay = day else {
            return allTimes
        }
        
        for time in isDay {
            allTimes.append(Time(string: time))
        }
        return allTimes
    }
    
    func getDayStringsFromDayTimes(day: [Time]?)->[String] {
        var allTimes = [String]()
        
        guard let isDay = day else {
            return allTimes
        }
        
        for time in isDay {
            allTimes.append(time.timeString)
        }
        return allTimes
    }
    
    func toAnyObject() -> Any {
        let dic = [
            kSunday: self.getDayStringsFromDayTimes(day: self.week[Day.sunday]),
            kMonday: self.getDayStringsFromDayTimes(day: self.week[Day.monday]),
            kTuesday: self.getDayStringsFromDayTimes(day: self.week[Day.tuesday]),
            kWednesday: self.getDayStringsFromDayTimes(day: self.week[Day.wednesday]),
            kThursday: self.getDayStringsFromDayTimes(day: self.week[Day.thursday]),
            kFriday: self.getDayStringsFromDayTimes(day: self.week[Day.friday]),
            kSaturday: self.getDayStringsFromDayTimes(day: self.week[Day.saturday])
            ] as [String : Any]
        
        return dic
    }
   
}
