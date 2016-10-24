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
    var task = Task(taskName: "",
        taskTime: Date(),
        taskVoiceURL: nil,
        taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""),
        taskTimePriorityHi : false
    )
    
    
    func startNewTask() {
        self.task = Task(taskName: "",
            taskTime: Date(),
            taskVoiceURL: nil,
            taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""),
            taskTimePriorityHi: false
        )
    }
    
    func getCurrenctTask()->Task {
        return self.task
    }

    func setCurrenctTask(_ task : Task) {
        self.task = task
    }
    
    //MARK: Setters

    func setTaskName(_ name : String) {
        self.task.taskName = name
    }
    
    func setTaskTime(_ date : Date) {
        if Date() < date {
            self.task.isTaskDone = false
        }
        self.task.taskTime = date
    }
    
    func setTaskVoiceURL(_ url : URL) {
        self.task.taskVoiceURL = url
    }
    
    func setTaskBeaconIdentifier(_ iBeaconIdentifier : IBeaconIdentifier) {
        self.task.taskBeaconIdentifier = iBeaconIdentifier
    }
    
    func setTaskTimePriority(_ hi : Bool) {
        self.task.taskTimePriorityHi = hi
    }


    //MARK: Getters
    
    func getTaskName()->String? {
        return self.task.taskName!
    }
    
    func getTaskTime()->Date? {
        return self.task.taskTime!
    }
    
    func getTaskVoiceURL()->URL? {
        return self.task.taskVoiceURL
    }
    
    func getTaskBeaconIdentifier()->IBeaconIdentifier? {
        return self.task.taskBeaconIdentifier!
    }
    
    func getTaskTimePriority()->Bool? {
        return self.task.taskTimePriorityHi
    }

}
