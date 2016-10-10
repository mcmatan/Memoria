//
//  Scheduler.swift
//  Memoria
//
//  Created by Matan Cohen on 3/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

protocol SchedulerDelegate {
    func notificationScheduledTime(_ task : Task)
}

class Scheduler : NSObject {
    var delegate : SchedulerDelegate?
    static var TaskNotificationKey : String = "majorAppendedByMinorString"
    let tasksDB : TasksDB
    
    init(tasksDB : TasksDB) {
        self.tasksDB = tasksDB
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(Scheduler.taskTimeNotification(_:)), name: NSNotification.Name(rawValue: NotificationsNames.TaskTimeNotification), object:nil)
    }
    
    internal func taskTimeNotification(_ notification : Notification) {
        if let localNotification = notification.object as? UILocalNotification {
            let key = Scheduler.TaskNotificationKey
            let majorAppendedByMinor = localNotification.userInfo![key] as? String
            guard let _ = majorAppendedByMinor else {
                return
            }
            let task = self.tasksDB.getTaskForIBeaconMajorAppendedByMinor(majorAppendedByMinor!)
            guard let isTask = task else {
                return
            }
            if let _ = self.delegate {
                    self.delegate!.notificationScheduledTime(isTask)
            }
        }
    }
    
    internal func squeduleReminderForTask(_ task : Task) {
        self.squeduleReminderForTask(task, date: task.taskTime!)
    }
    
    private func squeduleReminderForTask(_ task : Task, date: Date) {
        let alertBody = task.taskName
        let alertAction = task.taskName
        let fireDate = date
        let majorAppendedByMinorString = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        
        let notification = UILocalNotification()
        notification.alertBody = alertBody
        notification.alertAction = alertAction
        notification.fireDate = fireDate as Date?
        notification.timeZone = TimeZone.current
        notification.soundName = UILocalNotificationDefaultSoundName
        let key = Scheduler.TaskNotificationKey
        notification.userInfo = [key: majorAppendedByMinorString]
        notification.category = "Memoria"
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    internal func cancelReminderForTask(_ task : Task) {
        let key = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        var notificationToCancel : UILocalNotification?
        for notification in UIApplication.shared.scheduledLocalNotifications! {
            if notification.userInfo![Scheduler.TaskNotificationKey] as! String == key {
                notificationToCancel = notification
                break
            }
        }
        if let isNotification = notificationToCancel {
            UIApplication.shared.cancelLocalNotification(isNotification)
        }
        
        
    }


}
