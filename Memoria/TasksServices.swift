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
    private let beaconTracker: IbeaconsTracker
    fileprivate let taskNotificationsTracker : TaskNotificationsTracker

    init(tasksDB : TasksDB, scheduler : NotificationScheduler, taskNotificationsTracker : TaskNotificationsTracker, beaconTracker: IbeaconsTracker) {
        self.beaconTracker = beaconTracker
        self.scheduler = scheduler
        self.tasksDB = tasksDB
        self.taskNotificationsTracker = taskNotificationsTracker
    }
    
    func saveTask(_ task :Task) {
        self.scheduler.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
        self.beaconTracker.registerForBeacon(uuid: (task.taskBeaconIdentifier?.uuid)!, major: (task.taskBeaconIdentifier?.major)!, minor: (task.taskBeaconIdentifier?.minor)!)
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

    func removeTask(_ task : Task) {
        self.scheduler.cancelReminderForTask(task)
       let _ = self.tasksDB.removeTask(task)
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
