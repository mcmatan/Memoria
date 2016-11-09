//
//  Task.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class Task : NSObject {
    var taskTime: Date?
    var nearableIdentifer : String
    var taskTimePriorityHi : Bool?
    var isTaskDone = false
    var taskType: TaskType
    

    //Convinece
     init(
        taskType: TaskType,
        taskTime : Date?,
        nearableIdentifer : String,
        taskTimePriorityHi : Bool
        ) {
        self.taskTime = taskTime
        self.taskType = taskType
        self.nearableIdentifer = nearableIdentifer
        self.taskTimePriorityHi = taskTimePriorityHi
    }

    
    init(
        taskType: TaskType,
        taskTime : Date,
        nearableIdentifer : String,
        taskTimePriorityHi : Bool,
        isTaskDone :Bool
        ) {
            self.taskType = taskType
            self.taskTime = taskTime
            self.nearableIdentifer = nearableIdentifer
            self.taskTimePriorityHi = taskTimePriorityHi
            self.isTaskDone = isTaskDone
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let taskTime = aDecoder.decodeObject(forKey: "taskTime") as! Date
        let nearableIdentifer = aDecoder.decodeObject(forKey: "nearableIdentifer")
        let taskTimePriorityHi = aDecoder.decodeBool(forKey: "taskTimePriorityHi")
        let isTaskDone = aDecoder.decodeBool(forKey: "isTaskDone")
        let taskType = aDecoder.decodeObject(forKey: "taskType")
        self.init(taskType: TaskType(typeString: taskType as! String),
                  taskTime : taskTime,
                  nearableIdentifer : nearableIdentifer as! String,
                  taskTimePriorityHi : taskTimePriorityHi,
            isTaskDone: isTaskDone
        )
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(taskType.rawValue, forKey: "taskType")
        aCoder.encode(taskTime, forKey: "taskTime")
        aCoder.encode(nearableIdentifer, forKey: "nearableIdentifer")
        aCoder.encode(taskTimePriorityHi!, forKey: "taskTimePriorityHi")
        aCoder.encode(isTaskDone, forKey: "isTaskDone")
    }
}
