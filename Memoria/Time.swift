//
//  Time.swift
//  Memoria
//
//  Created by Matan Cohen on 23/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

struct Time {
    let hourString: String
    let minuteString: String
    let hour: Int
    let minute: Int
    let timeString: String
    
    init(date: Date) {
        let calendar = Calendar.current
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        
        hourString = hour > 9 ? "\(hour)" : "0\(hour)"
        minuteString = minute > 9 ? "\(minute)" : "0\(minute)"
        
        self.timeString = "\(hourString):\(minuteString)"
    }
    
    init(string: String) {
        self.timeString = string
        timeDateFormatter.dateFormat = "HH:mm"
        let date = timeDateFormatter.date(from: string)
        self.hour = (date?.hour)!
        self.minute = (date?.minute)!
        
        hourString = hour > 9 ? "\(hour)" : "0\(hour)"
        minuteString = minute > 9 ? "\(minute)" : "0\(minute)"
    }
    
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
        hourString = hour > 9 ? "\(hour)" : "0\(hour)"
        minuteString = minute > 9 ? "\(minute)" : "0\(minute)"
        self.timeString = "\(hourString):\(minuteString)"
    }
    
    static func addMinteToTime(minute: Int, hour: Int, day: Int, minuteToAdd: Int)->(minute: Int, hour: Int, day: Int) {
        var minteAfterAdd = minute + minuteToAdd
        var hourAfterAdd = hour
        var dayAfterAdd = day
        
        if minteAfterAdd > 60 {
           minteAfterAdd -= 60
            
            hourAfterAdd += 1
            
            if hourAfterAdd > 60 {
               hourAfterAdd -= 60
                
                dayAfterAdd += 1
                
                if dayAfterAdd > 7 {
                   dayAfterAdd -= 7
                }
            }
        }
        
        return (minteAfterAdd, hourAfterAdd, dayAfterAdd)
    }
}
