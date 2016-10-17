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
    
    func getTaskForIBeaconMajorAppendedByMinor(_ majorAppendedMyMinor : String) ->Task? {
        return self.tasksByMajorAppendedWithMinor[majorAppendedMyMinor]
    }
    
    func getTaskForIBeaconIdentifier(_ iBeaconIdentifier : IBeaconIdentifier) ->Task? {
        return self.getTaskForIBeaconMajorAppendedByMinor(iBeaconIdentifier.majorAppendedByMinorString())
    }
    
    func getTaskForCLBeacn(_ beacon : CLBeacon)->Task? {
        let beaconIdentifier = IBeaconIdentifier.creatFromCLBeacon(beacon)
        return self.getTaskForIBeaconIdentifier(beaconIdentifier)
    }
    
    func isTaskExistsForIbeaconIdentifier(_ iBeaconIdentifier : IBeaconIdentifier) ->Bool {
        if let _ = self.tasksByMajorAppendedWithMinor[iBeaconIdentifier.majorAppendedByMinorString()] {
            return true
        } else {
            return false
        }
    }
    
    func saveTask(_ task : Task) {
        if let isTaskBeaconIdentifier = task.taskBeaconIdentifier {
            self.tasksByMajorAppendedWithMinor[isTaskBeaconIdentifier.majorAppendedByMinorString()] = task
            self.saveDB()
            self.loadDB()
        } else {
         print("Did not save task!!!!!")   
        }
    }
    
    func removeTask(_ task : Task)->Bool {
        if let isTaskBeaconIdentifier = task.taskBeaconIdentifier {
            self.tasksByMajorAppendedWithMinor.removeValue(forKey: isTaskBeaconIdentifier.majorAppendedByMinorString())
            self.saveDB()
            self.loadDB()
            return true
        }
        return false

    }
    
    func getAllTasks()->[Task] {
        return Array(self.tasksByMajorAppendedWithMinor.values)
    }
    
    func isThereTaskForIBeaconIdentifier(_ iBeaconIdentifier : IBeaconIdentifier)->Bool {
        return self.isThereTaskForMajorAppendedByMinor(iBeaconIdentifier.majorAppendedByMinorString())  
    }

    func isThereTaskForMajorAppendedByMinor(_ MajorAppendedByMinor : String)->Bool {
        if let _ = self.tasksByMajorAppendedWithMinor[MajorAppendedByMinor] {
            return true
        } else {
            return false
        }
        
    }

    
    func saveDB() {
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.tasksByMajorAppendedWithMinor)
        userDefaults.set(encodedData, forKey: "tasks")
        userDefaults.synchronize()
    }
    
    func loadDB() {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: "tasks") as? Data
        
        if let isDecoded = decoded {
            if let isDecodedTasks = NSKeyedUnarchiver.unarchiveObject(with: isDecoded){
                if let isDecodedTasksAsStringToTask = isDecodedTasks as? [String : Task] {
                    self.tasksByMajorAppendedWithMinor = isDecodedTasksAsStringToTask
                }
            }

        }

        
        
    }
    
}
