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

    init(tasksDB : TasksDB,
         taskNotificationsTracker : TaskNotificationsTracker,
         nearableStriggerManager: NearableStriggerManager) {
        self.nearableStriggerManager = nearableStriggerManager
        self.tasksDB = tasksDB
        self.taskNotificationsTracker = taskNotificationsTracker
    }
    
    func saveTask(_ task :Task) {
        LocalNotificationScheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
        self.nearableStriggerManager.startTrackingForMotion(identifer: task.nearableIdentifer)
    }
    
    func snoozeTask(task: Task) {
        LocalNotificationScheduler.squeduleReminderForTask(task, date: Date() + snoozeMin.minutes)
    }

    func setTaskAsDone(_ task : Task) {
        task.isTaskDone = true
        LocalNotificationScheduler.cancelReminderForTask(task)
        self.tasksDB.saveTask(task)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kTaskDone), object: task, userInfo: nil)
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskMarkedAsDone, object: task, userInfo: nil)
    }
    
    func resqueduleTaskTimeTo(_ task : Task , time : Date) {
        LocalNotificationScheduler.cancelReminderForTask(task)
        task.taskTime = time
        LocalNotificationScheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func removeTask(_ task : Task) {
        LocalNotificationScheduler.cancelReminderForTask(task)
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
