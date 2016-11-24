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
//    
//    var sunday = [Time]()
//    var monday = [Time]()
//    var tuesday = [Time]()
//    var wednesday = [Time]()
//    var thursday = [Time]()
//    var friday = [Time]()
//    var saturday = [Time]()
    
    init(dic: [String: [String]]) {
        self.sunday = self.getDayTimesFromDayString(day: dic[kSunday])
        self.monday = self.getDayTimesFromDayString(day: dic[kMonday])
        self.tuesday = self.getDayTimesFromDayString(day: dic[kTuesday])
        self.wednesday = self.getDayTimesFromDayString(day: dic[kWednesday])
        self.thursday = self.getDayTimesFromDayString(day: dic[kThursday])
        self.friday = self.getDayTimesFromDayString(day: dic[kFriday])
        self.saturday = self.getDayTimesFromDayString(day: dic[kSunday])
    }
    
    init(dic: [Day: [Time]]) {
        if let isSunday = dic[Day.sunday] {
            self.sunday = isSunday
        }
        if let isMonday = dic[Day.monday] {
            self.monday = isMonday
        }
        if let isTusday = dic[Day.tuesday] {
            self.tuesday = isTusday
        }
        if let isWednesday = dic[Day.wednesday] {
            self.wednesday = isWednesday
        }
        if let isThusday = dic[Day.thursday] {
            self.thursday = isThusday
        }
        if let isFriday = dic[Day.friday] {
            self.friday = isFriday
        }
        if let isSaterday = dic[Day.saturday] {
            self.saturday = isSaterday
        }
        
    }
    
    init(withDayAndTime: (days: [Day], times: [Time])) { // This is only for the time beeing when you are can not input diffrent times for diffrent days for the same task
        for day in withDayAndTime.days {
            switch day {
            case Day.sunday:
                self.sunday = withDayAndTime.times
            case Day.monday:
                self.monday = withDayAndTime.times
            case Day.tuesday:
                self.tuesday = withDayAndTime.times
            case Day.wednesday:
                self.wednesday = withDayAndTime.times
            case Day.thursday:
                self.thursday = withDayAndTime.times
            case Day.friday:
                self.friday = withDayAndTime.times
            case Day.saturday:
                self.saturday = withDayAndTime.times
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
    
    func getDayStringsFromDayTimes(day: [Time])->[String] {
        var allTimes = [String]()
        for time in day {
            allTimes.append(time.timeString)
        }
        return allTimes
    }
    
    func toAnyObject() -> Any {
        let dic = [
            kSunday: self.getDayStringsFromDayTimes(day: self.sunday),
            kMonday: self.getDayStringsFromDayTimes(day: self.monday),
            kTuesday: self.getDayStringsFromDayTimes(day: self.tuesday),
            kWednesday: self.getDayStringsFromDayTimes(day: self.wednesday),
            kThursday: self.getDayStringsFromDayTimes(day: self.thursday),
            kFriday: self.getDayStringsFromDayTimes(day: self.friday),
            kSaturday: self.getDayStringsFromDayTimes(day: self.saturday)
            ] as [String : Any]
        
        return dic
    }
   
}
