//
//  NotificationsRemider.swift
//  Memoria
//
//  Created by Matan Cohen on 1/26/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class Reminder {
    static var TaskNotificationKey : String = "majorAppendedByMinorString"
    
    func squeduleReminderForTask(task : Task) {
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
        let key = Reminder.TaskNotificationKey
        notification.userInfo = [key: majorAppendedByMinorString]
        notification.category = "Memoria"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func cancelReminderForTask(task : Task) {
        let key = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        var notificationToCancel : UILocalNotification?
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo![Reminder.TaskNotificationKey] as! String == key {
                notificationToCancel = notification
                break
            }
        }
        if let isNotification = notificationToCancel {
                 UIApplication.sharedApplication().cancelLocalNotification(isNotification)
        }

        
    }
}