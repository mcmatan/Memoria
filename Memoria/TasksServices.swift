//
//  TasksServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import SwiftDate

let snoozeMin = 5

class TasksServices {
    private var tasksDB : TasksDB
    private let scheduler : NotificationScheduler
    private let nearableStriggerManager: NearableStriggerManager
    fileprivate let taskNotificationsTracker : TaskNotificationsTracker

    init(tasksDB : TasksDB,
         scheduler : NotificationScheduler,
         taskNotificationsTracker : TaskNotificationsTracker,
         nearableStriggerManager: NearableStriggerManager) {
        self.nearableStriggerManager = nearableStriggerManager
        self.scheduler = scheduler
        self.tasksDB = tasksDB
        self.taskNotificationsTracker = taskNotificationsTracker
    }
    
    func saveTask(_ task :Task) {
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
        self.nearableStriggerManager.startTrackingForMotion(identifer: task.nearableIdentifer)
    }
    
    func snoozeTask(task: Task) {
        self.scheduler.squeduleReminderForTask(task, date: Date() + snoozeMin.minutes)
    }

    func setTaskAsDone(_ task : Task) {
        task.isTaskDone = true
        self.scheduler.cancelReminderForTask(task)
        self.tasksDB.saveTask(task)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kTaskDone), object: task, userInfo: nil)
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskMarkedAsDone, object: task, userInfo: nil)
    }
    
    func resqueduleTaskTimeTo(_ task : Task , time : Date) {
        self.scheduler.cancelReminderForTask(task)
        task.taskTime = time
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func removeTask(_ task : Task) {
        self.scheduler.cancelReminderForTask(task)
        let _ = self.tasksDB.removeTask(task)
        self.nearableStriggerManager.stopTrackingForMotion(identifer: task.nearableIdentifer)
    }
    
    func getAllTasks()->[Task] {
       return self.tasksDB.getAllTasks()
    }
    
    func getTaskForNearableIdentifier(_ nearableIdentifer : String) ->Task {
        return self.tasksDB.getTaskForNearableIdentifer(nearableIdentifer)!
    }

}
