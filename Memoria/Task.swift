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
    taskType = "kTaskType",
    repeateOnDates = "repeateOnDates",
    compleateOnDates = "compleateOnDates",
    uid = "uid"
}

class Task : NSObject {
    var nearableIdentifer : String?
    var taskType: TaskType
    var repeateOnDates = RepeateOnDates()
    var compleateOnDates = CompleateOnDates()
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
        
        self.nearableIdentifer = snapshotValue[TaskPropNames.nearableIdentifer.rawValue] as? String
        self.taskType = TaskType(rawValue: snapshotValue[TaskPropNames.taskType.rawValue] as! String)!
        
        if let isCompleatedOnDates = snapshotValue[TaskPropNames.compleateOnDates.rawValue] as? [String : [String]] {
            self.compleateOnDates = CompleateOnDates(dic: isCompleatedOnDates)
        }
        
        if let isRepeateOnDates = snapshotValue[TaskPropNames.repeateOnDates.rawValue] as? [String : [String]] {
            self.repeateOnDates = RepeateOnDates(dic: isRepeateOnDates)
        }
        
        self.uid = snapshotValue[TaskPropNames.uid.rawValue] as! String
    }
    
    func toAnyObject() -> Any {
        
        var dic = [
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
        nearableIdentifer : String?
        ) {
            self.taskType = taskType
            self.nearableIdentifer = nearableIdentifer
            self.uid = "\(UUID.init().hashValue)"
            self.repeateOnDates = RepeateOnDates()
            self.compleateOnDates = CompleateOnDates()
    }
}
