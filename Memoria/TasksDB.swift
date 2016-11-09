//
//  TasksDB.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//



import Foundation


class TasksDB {
    var tasksByNearableIdentifer = [String : Task]()
    
    init() {
        self.loadDB()
    }

    func getTaskForNearableIdentifer(_ nearableIdentifer : String) ->Task? {
        return self.tasksByNearableIdentifer[nearableIdentifer]
    }
    
    func saveTask(_ task : Task) {
        self.tasksByNearableIdentifer[task.nearableIdentifer] = task
        self.saveDB()
        self.loadDB()
    }
    
    func removeTask(_ task : Task) {
        self.tasksByNearableIdentifer.removeValue(forKey: task.nearableIdentifer)
        self.saveDB()
        self.loadDB()
    }
    
    func getAllTasks()->[Task] {
        return Array(self.tasksByNearableIdentifer.values)
    }
    
    func isThereTaskForNearableIdentifier(_ nearableIdentifer : String)->Bool {
        if let _ = self.tasksByNearableIdentifer[nearableIdentifer] {
            return true
        } else {
            return false
        }
    }

    
    func saveDB() {
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.tasksByNearableIdentifer)
        userDefaults.set(encodedData, forKey: "tasks")
        userDefaults.synchronize()
    }
    
    func loadDB() {
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.object(forKey: "tasks") as? Data
        
        if let isDecoded = decoded {
            if let isDecodedTasks = NSKeyedUnarchiver.unarchiveObject(with: isDecoded){
                if let isDecodedTasksAsStringToTask = isDecodedTasks as? [String : Task] {
                    self.tasksByNearableIdentifer = isDecodedTasksAsStringToTask
                }
            }

        }

        
        
    }
    
}
