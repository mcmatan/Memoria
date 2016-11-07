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

        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskNotification(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskVerification(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskVerification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskWarning(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskWarning), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskMarkedAsDone(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskMarkedAsDone), object: nil)
    }
    
    //MARK: Public
    
    internal func presentTaskMarkedAsDone(_ notification : Notification) {
        let task = notification.object as? Task
        let text = "Task has marked as done"
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task!.taskBeaconIdentifier!, handler: { (result) -> Void in})
        })
        reminderPopUp.presentPopUp(task!.taskType.name(), message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in})
//        LocalNotificationPresenter.showLocalNotification(title: "Task was marked as done", subtitle: "Task name: \(task?.taskType.name)", body: "Tap to open", localNotificationCategory: LocalNotificationCategotry.done)
    }
    
    internal func presentTaskNotification(_ notification : Notification) {
        let task = notification.object as? Task
        let notificationPopUp = self.container.resolve(TaskNotificationPopUp.self, argument: task!)
        let mainViewController = UIApplication.shared.keyWindow?.rootViewController
        mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        
        LocalNotificationPresenter.showLocalNotificationForTask(task: task!, localNotificationCategotry: LocalNotificationCategotry.notification)
    }

    internal func presentTaskVerification(_ notification : Notification) {
        let task = notification.object as? Task
        let notificationPopUp = self.container.resolve(TaskVerificationPopUp.self, argument: task!)
        let mainViewController = UIApplication.shared.keyWindow?.rootViewController
        mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        
        LocalNotificationPresenter.showLocalNotificationForTask(task: task!, localNotificationCategotry: LocalNotificationCategotry.verification)
    }

    internal func presentTaskWarning(_ notification : Notification) {
        let task = notification.object as! Task
        let notificationPopUp = self.container.resolve(TaskWarningPopUp.self, argument: task)
        let mainViewController = UIApplication.shared.keyWindow?.rootViewController
        mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        
        LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.warning)
    }

}
