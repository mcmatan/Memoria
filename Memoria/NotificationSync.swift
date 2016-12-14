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
    let dataBase: DataBase
    var changeListener: EventListener<Any>?
    
    init(notificationScheduler: NotificationScheduler, dataBase: DataBase) {
        self.notificationScheduler = notificationScheduler
        self.dataBase = dataBase
        self.listenToChange()
    }
    
    func listenToChange() {
        self.changeListener = Events.shared.tasksChanged.on { event in
            self.syncNotifications()
        }
    }
    
    func syncNotifications() {
        self.notificationScheduler.cancelAllNotification()
        let allTasks = self.dataBase.getAllTasks()
        for task in allTasks {
            self.notificationScheduler.squeduleNotification(task: task)
        }
    }
    
}
