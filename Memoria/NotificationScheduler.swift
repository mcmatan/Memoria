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

protocol INotificationScheduler {
    func squeduleReminderForTask(_ task : Task)
    func cancelReminderForTask(_ task : Task)
}

class NotificationScheduler : NSObject, INotificationScheduler {
    static var TaskNotificationKey : String = "majorAppendedByMinorString"
    
    internal func squeduleReminderForTask(_ task : Task) {
        self.squeduleReminderForTask(task, date: task.taskTime!)
    }
    
    internal func squeduleReminderForTask(_ task : Task, date: Date) {
        let alertBody = task.taskName
        let alertAction = task.taskName
        let fireDate = date
        let majorAppendedByMinorString = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        
        let restartAction = UIMutableUserNotificationAction()
        restartAction.identifier = "xx"
        restartAction.isDestructive = false
        restartAction.title = "Restart"
        restartAction.activationMode = .background
        restartAction.isAuthenticationRequired = false
        
        let categoryIdentifier = "category.identifier"
        let category = UIMutableUserNotificationCategory()

        category.identifier = categoryIdentifier
        category.setActions([restartAction], for: .minimal)
        category.setActions([restartAction], for: .default)
        
        let categories = Set(arrayLiteral: category)
        let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.sound], categories: categories)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        
        let notification = UILocalNotification()
        notification.alertBody = alertBody
        notification.alertAction = alertAction
        notification.fireDate = fireDate as Date?
        notification.timeZone = TimeZone.current
        notification.applicationIconBadgeNumber = 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
        let key = NotificationScheduler.TaskNotificationKey
        notification.userInfo = [key: majorAppendedByMinorString]
        notification.category = categoryIdentifier
        squeduleReminderWithRepeat(notification: notification)
    }
    
    private func squeduleReminderWithRepeat(notification: UILocalNotification) {
        let numberOfReminders = 10
        for i in 0...numberOfReminders {
            let addedNotification = notification.copy() as! UILocalNotification
            addedNotification.fireDate = addedNotification.fireDate! + (10 * i).seconds
            UIApplication.shared.scheduleLocalNotification(addedNotification)
        }
    }
    
    internal func cancelReminderForTask(_ task : Task) {
        let key = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        var notificationToCancel : UILocalNotification?
        for notification in UIApplication.shared.scheduledLocalNotifications! {
            if notification.userInfo![NotificationScheduler.TaskNotificationKey] as! String == key {
                notificationToCancel = notification
                break
            }
        }
        if let isNotification = notificationToCancel {
            UIApplication.shared.cancelLocalNotification(isNotification)
        }
    }
}
