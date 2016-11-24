//
//  TasksServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import SwiftDate
import EmitterKit

let snoozeMin = 5

class TasksServices {
    private var tasksDB : TasksDB
    private let nearableStriggerManager: NearableStriggerManager
    let notificationScheduler: NotificationScheduler
    let notificationSync: NotificationSync

    init(tasksDB : TasksDB,
         nearableStriggerManager: NearableStriggerManager,
         notificationScheduler: NotificationScheduler,
         notificationSync: NotificationSync
        ) {
        self.notificationSync = notificationSync
        self.nearableStriggerManager = nearableStriggerManager
        self.tasksDB = tasksDB
        self.notificationScheduler = notificationScheduler
    }
    
    func saveTask(_ task :Task) {
        self.notificationScheduler.squeduleNotification(task: task)
        
        self.tasksDB.saveTask(task)
        
        if task.hasSticker() {
            self.nearableStriggerManager.startTrackingForMotion(identifer: task.nearableIdentifer!)
        }
    }

    func setTaskAsDone(task : Task) {
        //TBD Should add on task that I'ts one
        self.notificationScheduler.cancelNotification(task: task)
        self.tasksDB.saveTask(task)
        
        Events.shared.taskMarkedAsDone.emit(task)
    }

    func removeTask(_ task : Task) {
        self.notificationScheduler.cancelNotification(task: task)
        let _ = self.tasksDB.removeTask(task)
        
        if task.hasSticker() {
            self.nearableStriggerManager.stopTrackingForMotion(identifer: task.nearableIdentifer!)
        }
        
    }
    
    func stopRepeate(notificationIdnetifer: String) {
        self.notificationSync.syncNotifications() // This is async, so that is the reson for delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.notificationScheduler.stopRepeate(contentIdentifer: notificationIdnetifer)
        }
        self.notificationSync.syncAfter(min: 10)
    }
    
    func getAllTasks()->[Task] {
       return self.tasksDB.getAllTasks()
    }
    
    func getTask(taskUid: String)-> Task? {
        return self.tasksDB.getTask(taskUid: taskUid)
    }

}
