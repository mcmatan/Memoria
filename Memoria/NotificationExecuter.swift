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
    
    init(tasksDB : TasksDB) {
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
        if response.notification.request.content.categoryIdentifier == LocalNotificationCategotry.notification.rawValue {
            if let isTask = self.getTaskFromNotification(notification: response.notification) {
             NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kPresentTaskNotification), object: isTask, userInfo: nil)
            }
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
