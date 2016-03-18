//
//  TasksServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class TasksServices {
    let onHoldTimoutTimeInMinutes = 5
    var tasksDB : TasksDB
    let scheduler : Scheduler
    private let taskNotificationsTracker : TaskNotificationsTracker

    init(tasksDB : TasksDB, scheduler : Scheduler, taskNotificationsTracker : TaskNotificationsTracker) {
        self.scheduler = scheduler
        self.tasksDB = tasksDB
        self.taskNotificationsTracker = taskNotificationsTracker
    }
    
    func saveTask(task :Task) {
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }
    
    func setTaskIsOnHold(task : Task) { // This meents a timout will be made for the user to approch the task
        self.scheduler.cancelReminderForTask(task)
        task.taskTime = (task.taskTime! + onHoldTimoutTimeInMinutes.minutes)
        task.taskisOnHold = true
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func setTaskAsDone(task : Task) {
        self.taskNotificationsTracker.markTaskAsDone(task)
    }
    
    func resqueduleTaskTimeTo(task : Task , time : NSDate) {
        self.scheduler.cancelReminderForTask(task)
        task.taskTime = time
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func removeTask(task : Task)->Bool {
        self.scheduler.cancelReminderForTask(task)
       return self.tasksDB.removeTask(task)
    }
    
    func getAllTasks()->[Task] {
       return self.tasksDB.getAllTasks()
    }
    
    func getTaskForIBeaconIdentifier(iBeaconIdentifier : IBeaconIdentifier) ->Task {
        return self.getTaskForMajorAppendedByMinorString(iBeaconIdentifier.majorAppendedByMinorString())
    }

    func getTaskForMajorAppendedByMinorString(majorAppendedByMinorString : String) ->Task {
        return self.tasksDB.tasksByMajorAppendedWithMinor[majorAppendedByMinorString]!
    }

}