//
//  UINotificationExecuter.swift
//  Memoria
//
//  Created by Matan Cohen on 11/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import UserNotifications

class UINotificationExecuter: NSObject, UNUserNotificationCenterDelegate {
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
        print(#function)
        return //MC REMOVE
        let task = self.getTaskFromNotification(notification: notification)
        guard let isTask = task else {
            return
        }
        
        if isTask.isTaskDone == false {
            NotificationCenter.default.post(name: NotificationsNames.kPresentTaskNotification, object: task, userInfo: nil)
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
            NotificationCenter.default.post(name: NotificationsNames.kTask_Action_playSound,
                                            object: TaskActionDTO(task: isTask,
                                                                  localNotificationCategort: LocalNotificationCategotry.notification))
        case NotificationActionsInfos.verificationConfirm.identifer:
            NotificationCenter.default.post(name: NotificationsNames.kTask_Action_markAsDone,
                                            object: TaskActionDTO(task: isTask,
                                                                  localNotificationCategort: LocalNotificationCategotry.verification))
        case NotificationActionsInfos.verificationRemindMeLater.identifer:
            NotificationCenter.default.post(name: NotificationsNames.kTask_Action_Snooze,
                                            object: TaskActionDTO(task: isTask,
                                                                  localNotificationCategort: LocalNotificationCategotry.verification))
        case NotificationActionsInfos.warningThankYou.identifer: break
            default:
                let category = LocalNotificationCategoryBuilder.getLocalNotificationCategory(category: response.notification.request.content.categoryIdentifier)
                switch category {
                case LocalNotificationCategotry.done:
                    break;
                case LocalNotificationCategotry.notification:
                    self.tasksNotificationsPresenter.presentTaskNotification(task: task!, playSound: false)
                case LocalNotificationCategotry.verification:
                    self.tasksNotificationsPresenter.presentTaskVerification(task: task!, playSound: false)
                case LocalNotificationCategotry.warning:
                    self.tasksNotificationsPresenter.presentTaskWarning(task: task!, playSound: false)
        }
        
     }
    }
    
    func getTaskFromNotification(notification: UNNotification)->Task? {
        let key = NotificationScheduler.TaskNotificationKey
        let nearableIdentifer = notification.request.content.userInfo[key] as? String
        guard let isNearableIdentifer = nearableIdentifer else {
            return nil
        }
        let task = self.taskServices.getTaskForNearableIdentifier(isNearableIdentifer)
        return task
    }
}
