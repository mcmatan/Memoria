//
//  TasksNotificationsPresenter.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject


class TasksNotificationsPresenter : NSObject {
    let tasksServices : TasksServices
    let iBeaconServices : IBeaconServices
    let recorder : VoiceRecorder
    let reminderPopUp = ReminderPopUp()
    let container : Container
    
    init(tasksServices : TasksServices, iBeaconServices : IBeaconServices, container : Container) {
        self.tasksServices = tasksServices
        self.iBeaconServices = iBeaconServices
        self.recorder = VoiceRecorder()
        self.container = container
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskNotification(_:)), name: NotificationsNames.kPresentTaskNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskVerification(_:)), name: NotificationsNames.kPresentTaskVerification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskWarning(_:)), name: NotificationsNames.kPresentTaskWarning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskMarkedAsDone(_:)), name: NotificationsNames.kPresentTaskMarkedAsDone, object: nil)
    }
    
    //MARK: Public
    
    internal func presentTaskMarkedAsDone(_ notification : Notification) {
        let task = notification.object as? Task
        let text = "Task has marked as done"
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task!.taskBeaconIdentifier!, handler: { (result) -> Void in})
        })
        
        if UIApplication.isActive() == true {
            reminderPopUp.presentPopUp(task!.taskType.name(), message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in})
        }
        
        self.playSoundForTask(task: task!, localNotificationCategory: LocalNotificationCategotry.done)
    }
    
    //Notification
    internal func presentTaskNotification(_ notification : Notification) {
        let task = notification.object as? Task
        self.presentTaskNotification(task: task!, playSound: UIApplication.isActive())
    }
    
    internal func presentTaskNotification(task: Task, playSound: Bool) {
        if (UIApplication.isInBackground() == true) {
            LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.notification)
        }else {
            let notificationPopUp = self.container.resolve(TaskNotificationPopUp.self, argument: task)
            let mainViewController = UIApplication.shared.keyWindow?.rootViewController
            mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        }
        
        if playSound {
            self.playSoundForTask(task: task, localNotificationCategory: LocalNotificationCategotry.notification)
        }
    }

    //Verification
    internal func presentTaskVerification(_ notification : Notification) {
        let task = notification.object as? Task
        self.presentTaskVerification(task: task!, playSound: UIApplication.isActive())
    }
    
    internal func presentTaskVerification(task: Task, playSound: Bool) {
        if (UIApplication.isInBackground() == true) {
            LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.verification)
        } else {
            let notificationPopUp = self.container.resolve(TaskVerificationPopUp.self, argument: task)
            let mainViewController = UIApplication.shared.keyWindow?.rootViewController
            mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        }
        
        if playSound {
            self.playSoundForTask(task: task, localNotificationCategory: LocalNotificationCategotry.verification)
        }
    }

    //Warning
    internal func presentTaskWarning(_ notification : Notification) {
        let task = notification.object as! Task
        self.presentTaskWarning(task: task, playSound: UIApplication.isActive())
    }
    
    internal func presentTaskWarning(task: Task,  playSound: Bool) {
        if (UIApplication.isInBackground() == true) {
            LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.warning)
        } else {
            let notificationPopUp = self.container.resolve(TaskWarningPopUp.self, argument: task)
            let mainViewController = UIApplication.shared.keyWindow?.rootViewController
            mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        }
        
        if playSound {
            self.playSoundForTask(task: task, localNotificationCategory: LocalNotificationCategotry.warning)
        }
    }
    
    func playSoundForTask(task: Task, localNotificationCategory: LocalNotificationCategotry) {
        //The delayis becouse the task has a default sound of system that can not be removed for now, system apple bug
        NotificationCenter.default.post(name: NotificationsNames.kTask_Action_playSound, object: TaskActionDTO(task: task, localNotificationCategort: localNotificationCategory))
    }

}
