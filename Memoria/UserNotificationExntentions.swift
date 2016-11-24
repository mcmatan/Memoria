//
//  UserNotificationsTools.swift
//  Memoria
//
//  Created by Matan Cohen on 22/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UserNotifications

extension UNNotificationTrigger {
    static func with(hour: Int, minute: Int, day: Int)->UNNotificationTrigger {
        var fireDateRepeat = DateComponents()
        fireDateRepeat.hour = hour
        fireDateRepeat.minute = minute
        fireDateRepeat.weekday = day
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateRepeat, repeats: true)
        return trigger
    }
}

extension UNNotificationAttachment {
    static func with(imageURL: URL)->UNNotificationAttachment {
        let notificationImageAttachment = try! UNNotificationAttachment(identifier: "jpg_identifier", url:imageURL , options: nil)
        return notificationImageAttachment
    }
}

extension UNMutableNotificationContent {
    static func with(title: String,
                     subtitle: String,
                     body: String,
                     sound: UNNotificationSound,
                     userInfo: [String: String],
                     attachments: [UNNotificationAttachment]
        ) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.userInfo = userInfo
        content.attachments = attachments
        return content
    }
}

extension UNUserNotificationCenter {
    
    //Public
    static func add(task: Task, content: UNMutableNotificationContent) {
        for day in task.repeateOnDates.week.keys {
            let times = task.repeateOnDates.week[day]
            self.add(times: times, day: day, task: task, content: content)
          }
    }
    
    static func remove(task: Task) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { allReq in
            
            let taskType = task.taskType.rawValue
            let identifersToBeRemoved = allReq.filter{ return $0.identifier.contains(taskType) }.map{ $0.content.categoryIdentifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifersToBeRemoved)
        }
    }
    
    static func remove(task: Task, time: Time, day: Day) {
        let identifer = self.requestIndetifer(task: task, day: day, time: time)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifer])
    }
    
    //Private
    static func add(times: [Time]?, day: Day,task: Task, content: UNMutableNotificationContent) {
        if let isTimes = times {
            for time in isTimes {
                self.add(time: time, day: day, task: task, content: content)
            }
        }
    }
    
    static func add(time: Time, day: Day, task: Task, content: UNMutableNotificationContent) {
        
        let hour = time.hour
        let minute = time.minute
        let identifier = self.requestIndetifer(task: task,day: day, time: time)
        content.categoryIdentifier = identifier
        let requestIdentifier = identifier
        
        
        let trigger = UNNotificationTrigger.with(hour: hour, minute: minute, day: day.rawValue)
        
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content,trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let isError = error {
                print("Error on notification reuqest = \(isError)")
            }
        }
    }
    
    
    static func requestIndetifer(task: Task,day: Day, time: Time)-> String {
        return "\(task.taskType.rawValue)-\(day.stringLong())-\(time.timeString)"
    }
}
