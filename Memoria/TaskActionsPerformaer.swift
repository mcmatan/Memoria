//
//  NotificationsActionsPerformer.swift
//  Memoria
//
//  Created by Matan Cohen on 08/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate
import EmitterKit

class TaskActionsPerformer: NSObject {
    let recorder = VoiceRecorder()
    let taskServices: TasksServices
    
    var playSound: EventListener<Task>?
    var taskMarkedAsDone: EventListener<Task>?
    
    init(taskServices: TasksServices) {
        self.taskServices = taskServices
        super.init()
        self.regidterForEvents()
    }
    
    func regidterForEvents() {
        
        self.playSound = Events.shared.playSound.on { task in
            self.playSound(task: task)
        }
        
        self.taskMarkedAsDone = Events.shared.taskMarkedAsDone.on { task in
            self.markTaskAsDone(task: task)
        }
    }
    
    
    internal func playSound(task: Task) {
        let isSound = task.taskType.soundURL()
        if ("" != isSound.absoluteString) {
            self.recorder.soundFileURL = isSound as URL!
            self.recorder.play()
        }
    }
    
    internal func markTaskAsDone(task:Task) {
        self.taskServices.setTaskAsDone(task: task)
    }
    
}
