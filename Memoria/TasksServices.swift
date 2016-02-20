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
    let reminder : ReminderSqueduler

    init(tasksDB : TasksDB, reminder : ReminderSqueduler) {
        self.reminder = reminder
        self.tasksDB = tasksDB
    }
    
    func saveTask(task :Task) {
        self.reminder.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }
    
    func setTaskIsOnHold(task : Task) { // This meents a timout will be made for the user to approch the task
        self.reminder.cancelReminderForTask(task)
        task.taskTime = (task.taskTime! + onHoldTimoutTimeInMinutes.minutes)
        task.taskisOnHold = true
        self.reminder.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func setTaskAsDone(done : Bool, task : Task) {
        self.reminder.cancelReminderForTask(task)
        task.taskIsDone = done
        task.taskisOnHold = false
        if done == false {
         self.reminder.squeduleReminderForTask(task)
        }
        self.tasksDB.saveTask(task)
    }
    
    func resqueduleTaskTimeTo(task : Task , time : NSDate) {
        self.reminder.cancelReminderForTask(task)
        task.taskTime = time
        self.reminder.squeduleReminderForTask(task)
        self.tasksDB.saveTask(task)
    }

    func removeTask(task : Task)->Bool {
        self.reminder.cancelReminderForTask(task)
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