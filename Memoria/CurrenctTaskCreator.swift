//
//  CurrenctTaskCreator.swift
//  Memoria
//
//  Created by Matan Cohen on 1/23/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import SwiftDate

class CurrenctTaskCreator {
    
    class func emptyTask()->Task {
      return  Task(taskType: TaskType.drugs, taskTime: nil, nearableIdentifer: "", taskTimePriorityHi: false)
    }
    
    var task = CurrenctTaskCreator.emptyTask()
    
    
    func startNewTask() {
        self.task = CurrenctTaskCreator.emptyTask()
    }
    
    func getCurrenctTask()->Task {
        return self.task
    }

    func setCurrenctTask(_ task : Task) {
        self.task = task
    }
    
    //MARK: Setters

    func setTaskTime(_ date : Date) {
        if Date() < date {
            self.task.isTaskDone = false
        }
        self.task.taskTime = date
    }
    
    func setTaskNearableIdentifer(_ nearableIdentifer : String) {
        self.task.nearableIdentifer = nearableIdentifer
    }
    
    func setTaskTimePriority(_ hi : Bool) {
        self.task.taskTimePriorityHi = hi
    }
    
    func setTaskType(type: TaskType) {
        self.task.taskType = type
    }


    //MARK: Getters
    
    func getTaskTime()->Date? {
        return self.task.taskTime
    }
    
    func getTaskNearableIdentifer()->String {
        return self.task.nearableIdentifer
    }
    
    func getTaskTimePriority()->Bool? {
        return self.task.taskTimePriorityHi
    }

}
