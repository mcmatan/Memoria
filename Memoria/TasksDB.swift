//
//  TasksDB.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//



import Foundation


class TasksDB {
    var tasksByMajorAppendedWithMinor = [String : Task]()
    
    init() {
        self.loadDB()
    }
    
    func getTaskForIBeaconMajorAppendedByMinor(majorAppendedMyMinor : String) ->Task {
        return self.tasksByMajorAppendedWithMinor[majorAppendedMyMinor]!
    }
    
    func getTaskForIBeaconIdentifier(iBeaconIdentifier : IBeaconIdentifier) ->Task {
        return self.getTaskForIBeaconMajorAppendedByMinor(iBeaconIdentifier.majorAppendedByMinorString())
    }
    
    func isTaskExistsForIbeaconIdentifier(iBeaconIdentifier : IBeaconIdentifier) ->Bool {
        if let _ = self.tasksByMajorAppendedWithMinor[iBeaconIdentifier.majorAppendedByMinorString()] {
            return true
        } else {
            return false
        }
    }
    
    func saveTask(task : Task)->Bool {
        if let isTaskBeaconIdentifier = task.taskBeaconIdentifier {
            self.tasksByMajorAppendedWithMinor[isTaskBeaconIdentifier.majorAppendedByMinorString()] = task
            self.saveDB()
            self.loadDB()            
            return true
        }
        return false
    }
    
    func removeTask(task : Task)->Bool {
        if let isTaskBeaconIdentifier = task.taskBeaconIdentifier {
            self.tasksByMajorAppendedWithMinor.removeValueForKey(isTaskBeaconIdentifier.majorAppendedByMinorString())
            self.saveDB()
            self.loadDB()
            return true
        }
        return false

    }
    
    func getAllTasks()->[Task] {
        return Array(self.tasksByMajorAppendedWithMinor.values)
    }
    
    func isThereTaskForIBeaconIdentifier(iBeaconIdentifier : IBeaconIdentifier)->Bool {
        if let _ = self.tasksByMajorAppendedWithMinor[iBeaconIdentifier.majorAppendedByMinorString()] {
            return true
        } else {
            return false
        }

    }
    
    func saveDB() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(self.tasksByMajorAppendedWithMinor)
        userDefaults.setObject(encodedData, forKey: "tasks")
        userDefaults.synchronize()
    }
    
    func loadDB() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let decoded  = userDefaults.objectForKey("tasks") as? NSData
        
        if let isDecoded = decoded {
            if let isDecodedTasks = NSKeyedUnarchiver.unarchiveObjectWithData(isDecoded){
                if let isDecodedTasksAsStringToTask = isDecodedTasks as? [String : Task] {
                    self.tasksByMajorAppendedWithMinor = isDecodedTasksAsStringToTask
                }
            }

        }

        
        
    }
    
}