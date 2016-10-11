//
//  NotificationExecuter.swift
//  Memoria
//
//  Created by Matan Cohen on 11/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationExecuterDelegate {
    func notificationDidOccur(_ task : Task)
}

class NotificationExecuter: NSObject {
    var delegate : NotificationExecuterDelegate?
    let tasksDB : TasksDB
    
    init(tasksDB : TasksDB) {
        self.tasksDB = tasksDB
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationExecuter.notificationDidOccur(_:)), name: NSNotification.Name(rawValue: NotificationsNames.NotificationDidOccur), object:nil)
    }
    
    internal func notificationDidOccur(_ notification : Notification) {
        if let localNotification = notification.object as? UILocalNotification {
            let key = NotificationScheduler.TaskNotificationKey
            let majorAppendedByMinor = localNotification.userInfo![key] as? String
            guard let _ = majorAppendedByMinor else {
                return
            }
            let task = self.tasksDB.getTaskForIBeaconMajorAppendedByMinor(majorAppendedByMinor!)
            guard let isTask = task else {
                return
            }
            self.removeRepeatedNotifications(notification: localNotification)
            if let _ = self.delegate {
                self.delegate!.notificationDidOccur(isTask)
            }
        }
    }
    
    
    private func removeRepeatedNotifications(notification: UILocalNotification) {
        let allSqudulesNotifications = UIApplication.shared.scheduledLocalNotifications
        for sqeduledNotification in allSqudulesNotifications! {
            if sqeduledNotification.alertBody == notification.alertBody {
                UIApplication.shared.cancelLocalNotification(sqeduledNotification)
            }
        }
    }
}
