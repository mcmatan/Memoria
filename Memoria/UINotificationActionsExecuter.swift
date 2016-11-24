//
//  UINotificationActionsExecuter.swift
//  Memoria
//
//  Created by Matan Cohen on 11/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import UserNotifications
import EmitterKit

class UINotificationActionsExecuter: NSObject, UNUserNotificationCenterDelegate {
    let taskServices: TasksServices
    let tasksNotificationsPresenter: TasksNotificationsPresenter
    init(taskServices: TasksServices, tasksNotificationsPresenter: TasksNotificationsPresenter) {
        self.taskServices = taskServices
        self.tasksNotificationsPresenter = tasksNotificationsPresenter
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
        
        self.stopRepeateForNotification(notification: notification)
        
        print(#function)
        let task = self.getTaskFromNotification(notification: notification)
        guard let isTask = task else {
            return
        }

        Events.shared.presentTaskNotification.emit(isTask)    
    }
    
    //On Tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print(#function)
        
        self.stopRepeateForNotification(notification: response.notification)
        
        let task = self.getTaskFromNotification(notification: response.notification)
        guard let isTask = task else {
            return
        }
        
        switch response.actionIdentifier {
        case NotificationActionsInfos.playSound.identifer:
               Events.shared.playSound.emit(isTask)
        case NotificationActionsInfos.verificationConfirm.identifer:
            Events.shared.markTaskAsDone.emit(isTask)
        case NotificationActionsInfos.verificationRemindMeLater.identifer:
            print("Remind me later press")
        case NotificationActionsInfos.warningThankYou.identifer: break
            default:
                self.tasksNotificationsPresenter.presentTaskNotification(task: isTask, playSound: false)
        }
    }
    
    func stopRepeateForNotification(notification: UNNotification) {
        self.taskServices.stopRepeate(notificationIdnetifer: notification.request.identifier)
    }
    
    func getTaskFromNotification(notification: UNNotification)->Task? {
        let key = TaskNotificationUid
        let uid = notification.request.content.userInfo[key] as? String
        guard let isUid = uid else {
            return nil
        }
        let task = self.taskServices.getTask(taskUid: isUid)
        return task
    }
}
