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

class TaskActionsPerformer: NSObject {
    let recorder = VoiceRecorder()
    let taskServices: TasksServices
    
    init(taskServices: TasksServices) {
        self.taskServices = taskServices
        super.init()
        self.regidterForEvents()
    }
    
    func regidterForEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformer.playSound(notification:)), name: NotificationsNames.kTask_Action_playSound, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformer.markTaskAsDone(notification:)), name: NotificationsNames.kTask_Action_markAsDone, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformer.snooze(notification:)), name: NotificationsNames.kTask_Action_Snooze, object: nil)
    }
    
    
    internal func playSound(notification: NSNotification) {
        let taskActionDTO = notification.object as! TaskActionDTO
        let isSound = taskActionDTO.task.taskType.soundURL(localNotificationCategotry: taskActionDTO.localNotificationCategort)
        if ("" != isSound.absoluteString) {
            self.recorder.soundFileURL = isSound as URL!
            self.recorder.play()
        }
    }
    
    internal func markTaskAsDone(notification: NSNotification) {
        let taskActionDTO = notification.object as! TaskActionDTO
        self.taskServices.setTaskAsDone(taskActionDTO.task)
    }
    
    internal func snooze(notification: NSNotification) {
        let taskActionDTO = notification.object as! TaskActionDTO
        self.taskServices.snoozeTask(task: taskActionDTO.task)
    }
}
