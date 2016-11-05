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
import UserNotifications

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
        let majorAppendedByMinorString = task.taskBeaconIdentifier!.majorAppendedByMinorString()
        let key = NotificationScheduler.TaskNotificationKey
        let userInfo = [key: majorAppendedByMinorString]
        
        UIApplication.showLocalNotification(title: alertBody!, subtitle: alertBody!, body: "Tap to open", localNotificationCategory: LocalNotificationCategotry.notification, date: date, userInfo: userInfo)

    }
    
    internal func cancelReminderForTask(_ task : Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.taskName!])
    }
}
