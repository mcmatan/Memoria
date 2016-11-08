//
//  NotificationExecuter.swift
//  Memoria
//
//  Created by Matan Cohen on 11/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationExecuter: NSObject, UNUserNotificationCenterDelegate {
    let tasksDB : TasksDB
    let recorder = VoiceRecorder()
    let taskNotificationsTracker: TaskNotificationsTracker
    
    init(tasksDB : TasksDB, recorder: VoiceRecorder, taskNotificationsTracker: TaskNotificationsTracker) {
        self.taskNotificationsTracker = taskNotificationsTracker
        self.recorder = recorder
        self.tasksDB = tasksDB
        super.init()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let isError = error {
                print("Error when requestAuthorization! error = \(isError.localizedDescription)")
            }
        }
    }
    
    //UNUserNotificationCenterDelegate Delegate
    
    //On Show
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        print(#function)
        let task = self.getTaskFromNotification(notification: notification)
        guard let isTask = task else {
            return
        }
        
        if isTask.isTaskDone == false {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kPresentTaskNotification), object: task, userInfo: nil)
        }
    }
    
    //On Tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print(#function)
        
        let task = self.getTaskFromNotification(notification: response.notification)
        guard let isTask = task else {
            return
        }
        switch response.actionIdentifier {
        case NotificationActionsInfos.playSound.identifer:
            let isSound = isTask.taskType.soundURL(localNotificationCategotry: LocalNotificationCategotry.verification)
            if ("" != isSound.absoluteString) {
                self.recorder.soundFileURL = isSound as URL!
                self.recorder.play()
            }
        case NotificationActionsInfos.verificationConfirm.identifer:
            self.taskNotificationsTracker.markTaskAsDone(isTask)
        case NotificationActionsInfos.verificationRemindMeLater.identifer:
            self.scheduler.squeduleReminderForTask(task, date: Date() + snoozeMin.minutes)
        case NotificationActionsInfos.warningThankYou.identifer: break
            
        }
        
    }
    
    func getTaskFromNotification(notification: UNNotification)->Task? {
        let key = NotificationScheduler.TaskNotificationKey
        let majorAppendedByMinor = notification.request.content.userInfo[key] as? String
        guard let _ = majorAppendedByMinor else {
            return nil
        }
        let task = self.tasksDB.getTaskForIBeaconMajorAppendedByMinor(majorAppendedByMinor!)
        return task
    }
}
