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

    init(tasksDB : TasksDB,
         nearableStriggerManager: NearableStriggerManager,
         notificationScheduler: NotificationScheduler
        ) {
        self.nearableStriggerManager = nearableStriggerManager
        self.tasksDB = tasksDB
        self.notificationScheduler = notificationScheduler
    }
    
    func saveTask(_ task :Task) {
        self.notificationScheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
        
        if task.hasSticker() {
            self.nearableStriggerManager.startTrackingForMotion(identifer: task.nearableIdentifer!)
        }
        
    }
    
    func snoozeTask(task: Task) {
        self.notificationScheduler.squeduleReminderForTask(task, date: Date() + snoozeMin.minutes)
    }

    func setTaskAsDone(task : Task) {
        task.isTaskDone = true
        self.notificationScheduler.cancelReminderForTask(task)
        self.tasksDB.saveTask(task)
        
        Events.shared.taskMarkedAsDone.emit(task)
    }
    
    func resqueduleTaskTimeTo(_ task : Task , time : Date) {
        self.notificationScheduler.cancelReminderForTask(task)
        task.taskTime = time
        self.notificationScheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func removeTask(_ task : Task) {
        self.notificationScheduler.cancelReminderForTask(task)
        let _ = self.tasksDB.removeTask(task)
        
        if task.hasSticker() {
            self.nearableStriggerManager.stopTrackingForMotion(identifer: task.nearableIdentifer!)
        }
        
    }
    
    func getAllTasks()->[Task] {
       return self.tasksDB.getAllTasks()
    }
    
    func getTaskForNearableIdentifier(_ nearableIdentifer : String) ->Task {
        return self.tasksDB.getTaskForNearableIdentifer(nearableIdentifer)!
    }

}
