//
//  UserNotificationsTools.swift
//  Memoria
//
//  Created by Matan Cohen on 22/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftDate

let numberOfRepeates =  3
let repeateIntervalMin = 3

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
        content.sound = sound
        return content
    }
}

extension UNUserNotificationCenter {
    
    //Public
    static func add(task: Task, content: UNMutableNotificationContent, shouldRepeate: Bool) {
        for day in task.repeateOnDates.week.keys {
            let times = task.repeateOnDates.week[day]
            self.add(times: times, day: day, task: task, content: content, shouldRepeate: shouldRepeate)
          }
    }
    
    static func remove(task: Task) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { allReq in
            let taskType = task.taskType.rawValue
            let identifersToBeRemoved = allReq.filter{ return $0.identifier.contains(taskType) }.map{ $0.content.categoryIdentifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifersToBeRemoved)
        }
    }
    
    static func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func remove(task: Task, atTime: Time, andDay: Day) {
        let identifer = self.requestIndetifer(task: task, day: andDay, time: atTime)
        UNUserNotificationCenter.current().getPendingNotificationRequests { allReq in
            let identifersToBeRemoved = allReq.filter{ return $0.identifier.contains(identifer) }.map{ $0.content.categoryIdentifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifersToBeRemoved)
        }
    }
    
    static func stopRepeate(contentIdentifer: String) {
        
        var str = contentIdentifer
        
        if let dotRange = str.range(of: "||") {
            str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { allReq in
            let identifersToBeRemoved = allReq.filter{ return $0.identifier.contains(str) }.map{ $0.content.categoryIdentifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifersToBeRemoved)
        }
    }
    
    static func getNotificationsInfoJson(comletation: @escaping (_ discriptions: Array<String>)->Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { allReq in
            let discription = allReq.map({ req -> String in
                let identifer = req.content.categoryIdentifier
                let trigger = req.trigger as! UNCalendarNotificationTrigger
                let time = trigger.dateComponents.description
                return "\(identifer)\n&&DisplayTime=\(time)"
            })
            
            comletation(discription)
        }
    }
    
    //Private
    static func add(times: [Time]?, day: Day,task: Task, content: UNMutableNotificationContent,shouldRepeate: Bool) {
        if let isTimes = times {
            for time in isTimes {
                self.add(time: time, day: day, task: task, content: content, shouldRepeate: shouldRepeate)
            }
        }
    }
    
    static func add(time: Time, day: Day, task: Task, content: UNMutableNotificationContent, shouldRepeate: Bool) {
     
        let hour = time.hour
        let minute = time.minute
        
        let identifier = self.requestIndetifer(task: task,day: day, time: time)
        content.categoryIdentifier = identifier
        let requestIdentifier = identifier
        
        let trigger = UNNotificationTrigger.with(hour: hour, minute: minute, day: day.rawValue)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content,trigger: trigger)
        self.add(request: request)

    }
    
    static func add(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { (error) in
            if let isError = error {
                print("Error on notification reuqest = \(isError)")
            }
        }
    }
    
    
    static func requestIndetifer(task: Task,day: Day, time: Time)-> String {
        return "\(task.taskType.rawValue.uppercased())\nTIME:\n-\(day.stringLong())-\(time.timeString)"
    }
}
