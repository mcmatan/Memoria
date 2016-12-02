//
//  NotificationSync.swift
//  Memoria
//
//  Created by Matan Cohen on 24/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import SwiftDate
import EmitterKit

/*
 When tasks are changed on server, App should squedule notification too.
 */

class NotificationSync {
    let notificationScheduler: NotificationScheduler
    let tasksDB: TasksDB
    var changeListener: EventListener<Any>?
    
    init(notificationScheduler: NotificationScheduler, tasksDB: TasksDB) {
        self.notificationScheduler = notificationScheduler
        self.tasksDB = tasksDB
        self.listenToChange()
    }
    
    func listenToChange() {
        self.changeListener = Events.shared.tasksChanged.on { event in
            self.syncNotifications()
        }
    }
    
    func syncNotifications() {
        let allTasks = self.tasksDB.getAllTasks()
        for task in allTasks {
            self.notificationScheduler.squeduleNotification(task: task)
        }
    }
    
}
