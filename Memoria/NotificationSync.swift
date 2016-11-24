//
//  NotificationSync.swift
//  Memoria
//
//  Created by Matan Cohen on 24/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import SwiftDate

/*
 When booking a notification, we will book repeates as will.
 When enteting application, we will remove all repeates.
 When removing they will not come back at the next day, but, we remove then only from local notification, so we will reregister for all notifications every 24 hour
 */

class NotificationSync: NSObject {
    let lastDateKey = "lastDateKey"
    let taskDB: TasksDB
    let notificationScheduler: NotificationScheduler
    
    init(taskDB: TasksDB, notificationScheduler: NotificationScheduler) {
        self.taskDB = taskDB
        self.notificationScheduler = notificationScheduler
        super.init()
    }
    
    func syncNotifications() {
        let allTasks = self.taskDB.getAllTasks()
        for task in allTasks {
            self.notificationScheduler.squeduleNotification(task: task)
        }
    }
    
    func syncAfter(min: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(min * 60)) {
                self.syncNotifications()
        }
    }
}
