//
//  TasksServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class TasksServices {
    var tasksDB : TasksDB
    let reminder : Reminder

    init(tasksDB : TasksDB, reminder : Reminder) {
        self.reminder = reminder
        self.tasksDB = tasksDB
    }
    
    func saveTask(task :Task) {
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