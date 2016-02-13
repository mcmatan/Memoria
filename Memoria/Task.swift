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

    
    init(taskName : String, taskTime : NSDate, taskVoiceURL : NSURL, taskBeaconIdentifier : IBeaconIdentifier) {
        self.taskName = taskName
        self.taskTime = taskTime
        self.taskVoiceURL = taskVoiceURL
        self.taskBeaconIdentifier = taskBeaconIdentifier
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let taskName = aDecoder.decodeObjectForKey("taskName") as! String
        let taskTime = aDecoder.decodeObjectForKey("taskTime") as! NSDate
        let taskVoiceURL = aDecoder.decodeObjectForKey("taskVoiceURL") as! NSURL
        let taskBeaconIdentifier = aDecoder.decodeObjectForKey("taskBeaconIdentifier") as! IBeaconIdentifier
        self.init(taskName : taskName, taskTime : taskTime, taskVoiceURL : taskVoiceURL, taskBeaconIdentifier : taskBeaconIdentifier)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(taskName, forKey: "taskName")
        aCoder.encodeObject(taskTime, forKey: "taskTime")
        aCoder.encodeObject(taskVoiceURL, forKey: "taskVoiceURL")
        aCoder.encodeObject(taskBeaconIdentifier, forKey: "taskBeaconIdentifier")
    }
}
