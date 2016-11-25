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
        self.notificationScheduler.stopRepeate(contentIdentifer: notificationIdnetifer)
        self.notificationSync.syncAfter(min: 10)
    }
    
    func getAllTasks()->[Task] {
       return self.tasksDB.getAllTasks()
    }
    
    func getUpcomingTasksDisplays()->[TaskDisplay] {
        let all = self.getTaskDisplays()
        let now = Date()
        let upcoming = all.filter { taskDisplay -> Bool in
            return taskDisplay.date.isGreaterThanDate(now)
        }
        let orgenizedByDate =  upcoming.sorted(by: { $0.date.compare($1.date) == ComparisonResult.orderedAscending })
        return orgenizedByDate
    }
    
    func getUpcomingTaskDisplay()->TaskDisplay? {
        return self.getUpcomingTasksDisplays().first ?? nil
    }
    
    func getTaskDisplays()->[TaskDisplay] {
        let allTasks = self.getAllTasks()
        let today = Date().dayNumberOfWeek()
        var taskDisplays = [TaskDisplay]()
        
        for task in allTasks {
            if let isTimesToday = task.repeateOnDates.week[Day(rawValue:today)!] {
                for time in isTimesToday {
                    
                    let taskDate = Date().set(minute: time.minute, hour: time.hour)
                    let taskDisplay = TaskDisplay(task: task, date: taskDate)
                    taskDisplays.append(taskDisplay)
                }
            }
        }
        return taskDisplays
    }
    
    func getTask(taskUid: String)-> Task? {
        return self.tasksDB.getTask(taskUid: taskUid)
    }

}
