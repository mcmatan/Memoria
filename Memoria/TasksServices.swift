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
    private let nearableStriggerManager: NearableStriggerManager
    fileprivate let taskNotificationsTracker : TaskNotificationsTracker
    let localNotificationScheduler: LocalNotificationScheduler

    init(tasksDB : TasksDB,
         taskNotificationsTracker : TaskNotificationsTracker,
         nearableStriggerManager: NearableStriggerManager,
         localNotificationScheduler: LocalNotificationScheduler
        ) {
        self.nearableStriggerManager = nearableStriggerManager
        self.tasksDB = tasksDB
        self.taskNotificationsTracker = taskNotificationsTracker
        self.localNotificationScheduler = localNotificationScheduler
    }
    
    func saveTask(_ task :Task) {
        self.localNotificationScheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
        
        if task.hasSticker() {
            self.nearableStriggerManager.startTrackingForMotion(identifer: task.nearableIdentifer!)
        }
        
    }
    
    func snoozeTask(task: Task) {
        self.localNotificationScheduler.squeduleReminderForTask(task, date: Date() + snoozeMin.minutes)
    }

    func setTaskAsDone(_ task : Task) {
        task.isTaskDone = true
        self.localNotificationScheduler.cancelReminderForTask(task)
        self.tasksDB.saveTask(task)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kTaskDone), object: task, userInfo: nil)
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskMarkedAsDone, object: task, userInfo: nil)
    }
    
    func resqueduleTaskTimeTo(_ task : Task , time : Date) {
        self.localNotificationScheduler.cancelReminderForTask(task)
        task.taskTime = time
        self.localNotificationScheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func removeTask(_ task : Task) {
        self.localNotificationScheduler.cancelReminderForTask(task)
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
