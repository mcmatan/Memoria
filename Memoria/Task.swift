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
    var taskName: String?   
    var taskTime: NSDate?
    var taskVoiceURL: NSURL?
    var taskBeaconIdentifier : IBeaconIdentifier?
    var taskTimePriorityHi : Bool?
    var taskisOnHold = false // This is when user didnt do the task on time, and a interval is started to the future
    var standingNearFromDate : NSDate?
    var isTaskDone = false
    var timeLastWarningWasShow : NSDate?
    

    //Convinece
     init(taskName : String,
        taskTime : NSDate,
        taskVoiceURL : NSURL,
        taskBeaconIdentifier : IBeaconIdentifier,
        taskTimePriorityHi : Bool) {
        self.taskName = taskName
        self.taskTime = taskTime
        self.taskVoiceURL = taskVoiceURL
        self.taskBeaconIdentifier = taskBeaconIdentifier
        self.taskTimePriorityHi = taskTimePriorityHi
    }

    
    init(taskName : String,
        taskTime : NSDate,
        taskVoiceURL : NSURL,
        taskBeaconIdentifier : IBeaconIdentifier,
        taskTimePriorityHi : Bool,
        taskisOnHold : Bool,
        standingNearFromDate : NSDate?,
        timeLastWarningWasShow : NSDate?,
        isTaskDone :Bool
        ) {
            self.taskName = taskName
            self.taskTime = taskTime
            self.taskVoiceURL = taskVoiceURL
            self.taskBeaconIdentifier = taskBeaconIdentifier
            self.taskTimePriorityHi = taskTimePriorityHi
            self.isTaskDone = isTaskDone
            self.standingNearFromDate = standingNearFromDate
            self.timeLastWarningWasShow = timeLastWarningWasShow
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let taskName = aDecoder.decodeObjectForKey("taskName") as! String
        let taskTime = aDecoder.decodeObjectForKey("taskTime") as! NSDate
        let taskVoiceURL = aDecoder.decodeObjectForKey("taskVoiceURL") as! NSURL
        let taskBeaconIdentifier = aDecoder.decodeObjectForKey("taskBeaconIdentifier") as! IBeaconIdentifier
        let taskTimePriorityHi = aDecoder.decodeBoolForKey("taskTimePriorityHi")
        let taskisOnHold = aDecoder.decodeBoolForKey("taskisOnHold")
        let standingNearFromDate = aDecoder.decodeObjectForKey("standingNearFromDate") as! NSDate?
        let timeLastWarningWasShow = aDecoder.decodeObjectForKey("timeLastWarningWasShow") as! NSDate?
        let isTaskDone = aDecoder.decodeBoolForKey("isTaskDone")
        self.init(taskName : taskName, taskTime : taskTime, taskVoiceURL : taskVoiceURL, taskBeaconIdentifier : taskBeaconIdentifier , taskTimePriorityHi : taskTimePriorityHi,
            taskisOnHold : taskisOnHold,
            standingNearFromDate : standingNearFromDate,timeLastWarningWasShow : timeLastWarningWasShow, isTaskDone : isTaskDone)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(taskName, forKey: "taskName")
        aCoder.encodeObject(taskTime, forKey: "taskTime")
        aCoder.encodeObject(taskVoiceURL, forKey: "taskVoiceURL")
        aCoder.encodeObject(taskBeaconIdentifier, forKey: "taskBeaconIdentifier")
        aCoder.encodeBool(taskTimePriorityHi!, forKey: "taskTimePriorityHi")
        aCoder.encodeBool(isTaskDone, forKey: "isTaskDone")
        aCoder.encodeBool(taskisOnHold, forKey: "taskisOnHold")
        aCoder.encodeObject(standingNearFromDate, forKey: "standingNearFromDate")
        aCoder.encodeObject(timeLastWarningWasShow, forKey: "timeLastWarningWasShow")
    }
}
