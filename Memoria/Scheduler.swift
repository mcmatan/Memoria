//
//  Scheduler.swift
//  Memoria
//
//  Created by Matan Cohen on 3/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

protocol SchedulerDelegate {
    func notificationScheduledTime(task : Task)
}

class Scheduler : NSObject {
    var delegate : SchedulerDelegate?
    static var TaskNotificationKey : String = "majorAppendedByMinorString"
    let tasksDB : TasksDB
    
    init(tasksDB : TasksDB) {
        self.tasksDB = tasksDB
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("taskTimeNotification:"), name: NotificationsNames.TaskTimeNotification, object:nil)
    }
    
    internal func taskTimeNotification(notification : NSNotification) {
        if let localNotification = notification.object as? UILocalNotification {
            let key = Scheduler.TaskNotificationKey
            let majorAppendedByMinor = localNotification.userInfo![key] as? String
            let task = self.tasksDB.getTaskForIBeaconMajorAppendedByMinor(majorAppendedByMinor!)
                if let isTask = task {
                    if let isDelegate = self.delegate {
                            self.delegate!.notificationScheduledTime(isTask)
                    }
                }
        }
    }
    
    internal func squeduleReminderForTask(task : Task) {
        let alertBody = task.taskName
        let alertAction = task.taskName
        let fireDate = task.taskTime
        let majorAppendedByMinorString = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        
        let notification = UILocalNotification()
        notification.alertBody = alertBody
        notification.alertAction = alertAction
        notification.fireDate = fireDate
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.soundName = UILocalNotificationDefaultSoundName
        let key = Scheduler.TaskNotificationKey
        notification.userInfo = [key: majorAppendedByMinorString]
        notification.category = "Memoria"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    internal func cancelReminderForTask(task : Task) {
        let key = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        var notificationToCancel : UILocalNotification?
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo![Scheduler.TaskNotificationKey] as! String == key {
                notificationToCancel = notification
                break
            }
        }
        if let isNotification = notificationToCancel {
            UIApplication.sharedApplication().cancelLocalNotification(isNotification)
        }
        
        
    }


}