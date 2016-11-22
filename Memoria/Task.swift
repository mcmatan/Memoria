//
//  Task.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


enum TaskPropNames: String {
    case taskTime =  "taskTime",
    nearableIdentifer =  "nearableIdentifer",
    taskTimePriorityHi = "taskTimePriorityHi",
    isTaskDone = "isTaskDone",
    taskType = "kTaskType",
    repeateOnDates = "repeateOnDates",
    compleateOnDates = "compleateOnDates",
    uid = "uid"
}

class Task : NSObject {
    var nearableIdentifer : String?
    var taskTimePriorityHi : Bool
    var isTaskDone = false
    var taskType: TaskType
    var repeateOnDates: RepeateOnDates
    var compleateOnDates: CompleateOnDates
    let uid: String
    
    func hasSticker() -> Bool {
        if let _ = self.nearableIdentifer {
            return true
        } else {
            return false
        }
    }
    
    init(dic: Dictionary<String, Any>) {
        let snapshotValue = dic
        let taskTime = snapshotValue[TaskPropNames.taskTime.rawValue] as! TimeInterval
        let taskTimeAsDate = Date(timeIntervalSince1970: TimeInterval(taskTime))
        self.nearableIdentifer = snapshotValue[TaskPropNames.nearableIdentifer.rawValue] as? String
        self.taskTimePriorityHi = snapshotValue[TaskPropNames.taskTimePriorityHi.rawValue] as! Bool
        self.isTaskDone = snapshotValue[TaskPropNames.isTaskDone.rawValue] as! Bool
        self.taskType = TaskType(rawValue: snapshotValue[TaskPropNames.taskType.rawValue] as! String)!
        self.repeateOnDates = RepeateOnDates(dic: snapshotValue[TaskPropNames.repeateOnDates.rawValue] as! [String : [String]])
        self.compleateOnDates = CompleateOnDates(dic: snapshotValue[TaskPropNames.compleateOnDates.rawValue] as! [String : [String]])
        self.uid = snapshotValue[TaskPropNames.uid.rawValue] as! String
    }
    
    func toAnyObject() -> Any {
        
        var dic = [
            TaskPropNames.taskTimePriorityHi.rawValue: taskTimePriorityHi,
            TaskPropNames.isTaskDone.rawValue: isTaskDone,
            TaskPropNames.taskType.rawValue: taskType.rawValue,
            TaskPropNames.repeateOnDates.rawValue: repeateOnDates.toAnyObject(),
            TaskPropNames.compleateOnDates.rawValue: compleateOnDates.toAnyObject(),
            TaskPropNames.uid.rawValue: uid
        ] as [String : Any]
        
        if let isNearableIdentifer = nearableIdentifer {
            dic[TaskPropNames.nearableIdentifer.rawValue] = isNearableIdentifer
        }
        
        return dic
    }
    
    init(
        taskType: TaskType,
        taskTime : Date?,
        nearableIdentifer : String?,
        taskTimePriorityHi : Bool,
        isTaskDone :Bool
        ) {
            self.taskType = taskType
            self.nearableIdentifer = nearableIdentifer
            self.taskTimePriorityHi = taskTimePriorityHi
            self.isTaskDone = isTaskDone
            self.uid = "\(UUID.init().hashValue)"
            self.repeateOnDates = RepeateOnDates()
            self.compleateOnDates = CompleateOnDates()
    }
}
