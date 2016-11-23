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
    
    var task = CurrenctTaskCreator.emptyTask()
    
    class func emptyTask()->Task {
        return  Task(taskType: TaskType.drugs, taskTime: nil, nearableIdentifer: nil, taskTimePriorityHi: false ,isTaskDone: false)
    }
    
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
    
    func getTaskNearableIdentifer()->String? {
        return self.task.nearableIdentifer
    }
    
    func getTaskTimePriority()->Bool? {
        return self.task.taskTimePriorityHi
    }

}
