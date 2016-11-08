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

class TaskActionsPerformaer: NSObject {
    let recorder = VoiceRecorder()
    let taskServices: TasksServices
    
    init(taskServices: TasksServices) {
        self.taskServices = taskServices
        super.init()
        self.regidterForEvents()
    }
    
    func regidterForEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformaer.playSound(notification:)), name: NotificationsNames.kTask_Action_playSound, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformaer.markTaskAsDone(notification:)), name: NotificationsNames.kTask_Action_markAsDone, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformaer.snooze(notification:)), name: NotificationsNames.kTask_Action_Snooze, object: nil)
    }
    
    
    internal func playSound(notification: NSNotification) {
        let task = notification.object as! Task
        let isSound = task.taskType.soundURL(localNotificationCategotry: LocalNotificationCategotry.verification)
        if ("" != isSound.absoluteString) {
            self.recorder.soundFileURL = isSound as URL!
            self.recorder.play()
        }
    }
    
    internal func markTaskAsDone(notification: NSNotification) {
        let task = notification.object as! Task
        self.taskServices.setTaskAsDone(task)
    }
    
    internal func snooze(notification: NSNotification) {
        let task = notification.object as! Task
        self.taskServices.snoozeTask(task: task)
    }
}
