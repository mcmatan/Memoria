//
//  NotificationsActionsPerformer.swift
//  Memoria
//
//  Created by Matan Cohen on 08/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class TaskActionsPerformaer: NSObject {
    let recorder = VoiceRecorder()
    let taskNotificationsTracker: TaskNotificationsTracker
    let notificationScheduler: NotificationScheduler
    
    init(notificationScheduler: NotificationScheduler, taskNotificationsTracker: TaskNotificationsTracker) {
        self.taskNotificationsTracker = taskNotificationsTracker
        self.notificationScheduler = notificationScheduler
        super.init()
        self.regidterForEvents()
    }
    
    func regidterForEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformaer.playSound), name: NotificationsNames.kTask_Action_playSound, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformaer.markTaskAsDone), name: NotificationsNames.kTask_Action_markAsDone, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskActionsPerformaer.snooze(_:)), name: NotificationsNames.kTask_Action_Snooze, object: nil)
    }
    
    
    func playSound(notification: NSNotification) {
        let task = notification.object as! Task
        let isSound = task.taskType.soundURL(localNotificationCategotry: LocalNotificationCategotry.verification)
        if ("" != isSound.absoluteString) {
            self.recorder.soundFileURL = isSound as URL!
            self.recorder.play()
    }
    
    func markTaskAsDone(notification: NSNotification) {
        let task = notification.object as! Task
        self.taskNotificationsTracker.markTaskAsDone(task)
    }
    
    func snooze(notification: NSNotification) {
        self.scheduler.squeduleReminderForTask(task, date: Date() + snoozeMin.minutes)
        }
    }
}
