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
    
    init(taskServices: TasksServices) {
        self.taskServices = taskServices
        super.init()
        self.regidterForEvents()
    }
    
    func regidterForEvents() {
        
        Events.shared.playSound.on { task in
            self.playSound(task: task)
        }
        
        Events.shared.taskMarkedAsDone.on { task in
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
    
    internal func markTaskAsDone(task:task) {
        self.taskServices.setTaskAsDone(task: task)
    }
    
}
