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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("presentTaskNotification:"), name: NotificationsNames.kPresentTaskNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("presentTaskVerification:"), name: NotificationsNames.kPresentTaskVerification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("presentTaskWarning:"), name: NotificationsNames.kPresentTaskWarning, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("presentTaskMarkedAsDone:"), name: NotificationsNames.kPresentTaskMarkedAsDone, object: nil)
    }
    
    //MARK: Public
    
    internal func presentTaskMarkedAsDone(notification : NSNotification) {
        let task = notification.object as? Task
        let text = "Task has marked as done"
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task!.taskBeaconIdentifier!, handler: { (result) -> Void in})
        })
        reminderPopUp.presentPopUp(task!.taskName!, message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in})
    }
    
    internal func presentTaskNotification(notification : NSNotification) {
        let task = notification.object as? Task
        let notificationPopUp = self.container.resolve(TaskNotificationPopUp.self, argument: task!)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(notificationPopUp!, animated: true, completion: nil)
    }

    internal func presentTaskVerification(notification : NSNotification) {
        let task = notification.object as? Task
        let notificationPopUp = self.container.resolve(TaskVerificationPopUp.self, argument: task!)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(notificationPopUp!, animated: true, completion: nil)
    }

    internal func presentTaskWarning(notification : NSNotification) {
        let task = notification.object as? Task
        let notificationPopUp = self.container.resolve(TaskWarningPopUp.self, argument: task!)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(notificationPopUp!, animated: true, completion: nil)
    }

}