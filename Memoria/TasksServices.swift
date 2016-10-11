//
//  TasksServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import SwiftDate

class TasksServices {
    private let snoozeMin = 5
    private var tasksDB : TasksDB
    private let scheduler : NotificationScheduler
    fileprivate let taskNotificationsTracker : TaskNotificationsTracker

    init(tasksDB : TasksDB, scheduler : NotificationScheduler, taskNotificationsTracker : TaskNotificationsTracker) {
        self.scheduler = scheduler
        self.tasksDB = tasksDB
        self.taskNotificationsTracker = taskNotificationsTracker
    }
    
    func saveTask(_ task :Task) {
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }
    
    func snoozeTask(task: Task) {
        self.scheduler.squeduleReminderForTask(task, date: Date() + snoozeMin.minutes)
    }

    func setTaskAsDone(_ task : Task) {
        self.taskNotificationsTracker.markTaskAsDone(task)
    }
    
    func resqueduleTaskTimeTo(_ task : Task , time : Date) {
        self.scheduler.cancelReminderForTask(task)
        task.taskTime = time
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func removeTask(_ task : Task)->Bool {
        self.scheduler.cancelReminderForTask(task)
       return self.tasksDB.removeTask(task)
    }
    
    func getAllTasks()->[Task] {
       return self.tasksDB.getAllTasks()
    }
    
    func getTaskForIBeaconIdentifier(_ iBeaconIdentifier : IBeaconIdentifier) ->Task {
        return self.getTaskForMajorAppendedByMinorString(iBeaconIdentifier.majorAppendedByMinorString())
    }

    func getTaskForMajorAppendedByMinorString(_ majorAppendedByMinorString : String) ->Task {
        return self.tasksDB.tasksByMajorAppendedWithMinor[majorAppendedByMinorString]!
    }

}
