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
    var taskBeaconIdentifier : IBeaconIdentifier?
    var taskTimePriorityHi : Bool?
    var standingNearFromDate : Date?
    var isTaskDone = false
    var timeLastWarningWasShow : Date?
    var timeLastVerifyWasShow : Date?
    var taskType: TaskType
    

    //Convinece
     init(
        taskType: TaskType,
        taskTime : Date,
        taskBeaconIdentifier : IBeaconIdentifier,
        taskTimePriorityHi : Bool
        ) {
        self.taskTime = taskTime
        self.taskType = taskType
        self.taskBeaconIdentifier = taskBeaconIdentifier
        self.taskTimePriorityHi = taskTimePriorityHi
    }

    
    init(
        taskType: TaskType,
        taskTime : Date,
        taskBeaconIdentifier : IBeaconIdentifier,
        taskTimePriorityHi : Bool,
        standingNearFromDate : Date?,
        timeLastWarningWasShow : Date?,
        isTaskDone :Bool
        ) {
            self.taskType = taskType
            self.taskTime = taskTime
            self.taskBeaconIdentifier = taskBeaconIdentifier
            self.taskTimePriorityHi = taskTimePriorityHi
            self.isTaskDone = isTaskDone
            self.standingNearFromDate = standingNearFromDate
            self.timeLastWarningWasShow = timeLastWarningWasShow
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let taskTime = aDecoder.decodeObject(forKey: "taskTime") as! Date
        let taskBeaconIdentifier = aDecoder.decodeObject(forKey: "taskBeaconIdentifier") as! IBeaconIdentifier
        let taskTimePriorityHi = aDecoder.decodeBool(forKey: "taskTimePriorityHi")
        let standingNearFromDate = aDecoder.decodeObject(forKey: "standingNearFromDate") as! Date?
        let timeLastWarningWasShow = aDecoder.decodeObject(forKey: "timeLastWarningWasShow") as! Date?
        let isTaskDone = aDecoder.decodeBool(forKey: "isTaskDone")
        let taskType = aDecoder.decodeObject(forKey: "taskType")
        self.init(taskType: TaskType(typeString: taskType as! String),
                  taskTime : taskTime,
                  taskBeaconIdentifier : taskBeaconIdentifier ,
                  taskTimePriorityHi : taskTimePriorityHi,
                  standingNearFromDate : standingNearFromDate,
                  timeLastWarningWasShow : timeLastWarningWasShow,
                  isTaskDone : isTaskDone
        )
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(taskType, forKey: "taskType")
        aCoder.encode(taskTime, forKey: "taskTime")
        aCoder.encode(taskBeaconIdentifier, forKey: "taskBeaconIdentifier")
        aCoder.encode(taskTimePriorityHi!, forKey: "taskTimePriorityHi")
        aCoder.encode(isTaskDone, forKey: "isTaskDone")
        aCoder.encode(standingNearFromDate, forKey: "standingNearFromDate")
        aCoder.encode(timeLastWarningWasShow, forKey: "timeLastWarningWasShow")
    }
}
