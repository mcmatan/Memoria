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
    var taskTime: Date?
    var taskVoiceURL: URL?
    var taskBeaconIdentifier : IBeaconIdentifier?
    var taskTimePriorityHi : Bool?
    var standingNearFromDate : Date?
    var isTaskDone = false
    var timeLastWarningWasShow : Date?
    var timeLastVerifyWasShow : Date?
    

    //Convinece
     init(taskName : String,
        taskTime : Date,
        taskVoiceURL : URL?,
        taskBeaconIdentifier : IBeaconIdentifier,
        taskTimePriorityHi : Bool) {
        self.taskName = taskName
        self.taskTime = taskTime
        self.taskVoiceURL = taskVoiceURL
        self.taskBeaconIdentifier = taskBeaconIdentifier
        self.taskTimePriorityHi = taskTimePriorityHi
    }

    
    init(taskName : String,
        taskTime : Date,
        taskVoiceURL : URL,
        taskBeaconIdentifier : IBeaconIdentifier,
        taskTimePriorityHi : Bool,
        standingNearFromDate : Date?,
        timeLastWarningWasShow : Date?,
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
        let taskName = aDecoder.decodeObject(forKey: "taskName") as! String
        let taskTime = aDecoder.decodeObject(forKey: "taskTime") as! Date
        let taskVoiceURL = aDecoder.decodeObject(forKey: "taskVoiceURL") as! URL
        let taskBeaconIdentifier = aDecoder.decodeObject(forKey: "taskBeaconIdentifier") as! IBeaconIdentifier
        let taskTimePriorityHi = aDecoder.decodeBool(forKey: "taskTimePriorityHi")
        let standingNearFromDate = aDecoder.decodeObject(forKey: "standingNearFromDate") as! Date?
        let timeLastWarningWasShow = aDecoder.decodeObject(forKey: "timeLastWarningWasShow") as! Date?
        let isTaskDone = aDecoder.decodeBool(forKey: "isTaskDone")
        self.init(taskName : taskName, taskTime : taskTime, taskVoiceURL : taskVoiceURL, taskBeaconIdentifier : taskBeaconIdentifier , taskTimePriorityHi : taskTimePriorityHi,
            standingNearFromDate : standingNearFromDate,timeLastWarningWasShow : timeLastWarningWasShow, isTaskDone : isTaskDone)
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(taskName, forKey: "taskName")
        aCoder.encode(taskTime, forKey: "taskTime")
        aCoder.encode(taskVoiceURL, forKey: "taskVoiceURL")
        aCoder.encode(taskBeaconIdentifier, forKey: "taskBeaconIdentifier")
        aCoder.encode(taskTimePriorityHi!, forKey: "taskTimePriorityHi")
        aCoder.encode(isTaskDone, forKey: "isTaskDone")
        aCoder.encode(standingNearFromDate, forKey: "standingNearFromDate")
        aCoder.encode(timeLastWarningWasShow, forKey: "timeLastWarningWasShow")
    }
}
