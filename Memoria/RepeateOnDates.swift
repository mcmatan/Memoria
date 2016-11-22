//
//  TaskRepeateDates.swift
//  Memoria
//
//  Created by Matan Cohen on 22/11/2016.
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

class Time {
    let hours: Int
    let minutes: Int
    let string: String
    init(string: String) {
        self.string = string
        timeDateFormatter.dateFormat = "hh:mm"
        let date = timeDateFormatter.date(from: string)
        self.hours = (date?.hour)!
        self.minutes = (date?.minute)!
    }
}

class RepeateOnDates {
    var sunday = [Time]()
    var monday = [Time]()
    var tuesday = [Time]()
    var wednesday = [Time]()
    var thursday = [Time]()
    var friday = [Time]()
    var saturday = [Time]()
    
    init(dic: [String: [String]]) {
        self.sunday = self.getDayTimesFromDayString(day: dic[kSunday]!)
        self.monday = self.getDayTimesFromDayString(day: dic[kMonday]!)
        self.tuesday = self.getDayTimesFromDayString(day: dic[kTuesday]!)
        self.wednesday = self.getDayTimesFromDayString(day: dic[kWednesday]!)
        self.thursday = self.getDayTimesFromDayString(day: dic[kThursday]!)
        self.friday = self.getDayTimesFromDayString(day: dic[kFriday]!)
        self.saturday = self.getDayTimesFromDayString(day: dic[kSunday]!)
    }
    
    init() {
        
    }
    
    func getDayTimesFromDayString(day: [String])->[Time] {
        var allTimes = [Time]()
        for time in day {
            allTimes.append(Time(string: time))
        }
        return allTimes
    }
    
    func getDayStringsFromDayTimes(day: [Time])->[String] {
        var allTimes = [String]()
        for time in day {
            allTimes.append(time.string)
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

