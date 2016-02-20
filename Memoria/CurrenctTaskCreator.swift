//
//  CurrenctTaskCreator.swift
//  Memoria
//
//  Created by Matan Cohen on 1/23/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class CurrenctTaskCreator {
    var task = Task(taskName: "",
        taskTime: NSDate(),
        taskVoiceURL: NSURL(),
        taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""),
        taskTimePriorityHi : false
    )
    
    
    func startNewTask() {
        self.task = Task(taskName: "",
            taskTime: NSDate(),
            taskVoiceURL: NSURL(),
            taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""),
            taskTimePriorityHi: false
        )
    }
    
    func getCurrenctTask()->Task {
        return self.task
    }

    func setCurrenctTask(task : Task) {
        self.task = task
    }

    
    //MARK: Setters

    func setTaskName(name : String) {
        self.task.taskName = name
    }
    
    func setTaskTime(date : NSDate) {
        self.task.taskTime = date
    }
    
    func setTaskVoiceURL(url : NSURL) {
        self.task.taskVoiceURL = url
    }
    
    func setTaskBeaconIdentifier(iBeaconIdentifier : IBeaconIdentifier) {
        self.task.taskBeaconIdentifier = iBeaconIdentifier
    }
    
    func setTaskTimePriority(hi : Bool) {
        self.task.taskTimePriorityHi = hi
    }


    //MARK: Getters
    
    func getTaskName()->String? {
        return self.task.taskName!
    }
    
    func getTaskTime()->NSDate? {
        return self.task.taskTime!
    }
    
    func getTaskVoiceURL()->NSURL? {
        return self.task.taskVoiceURL
    }
    
    func getTaskBeaconIdentifier()->IBeaconIdentifier? {
        return self.task.taskBeaconIdentifier!
    }
    
    func getTaskTimePriority()->Bool? {
        return self.task.taskTimePriorityHi
    }

}