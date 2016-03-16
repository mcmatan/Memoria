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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("taskTimeNotification:"), name: NotificationsNames.TaskTimeNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("tryingToPerformTaskWithHiPriorityBeforeTimeScheduledNotifiationRecevied:"), name: NotificationsNames.tryingToPerformTaskBeforeTimeScheduledNotifiationWithHiPriority, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("tryingToPerformTaskWithLowPriorityBeforeTimeScheduledNotifiationRecevied:"), name: NotificationsNames.tryingToPerformTaskBeforeTimeScheduledNotifiationWithLowPriority, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("tryingToPerformTaskWithHiPriorityAfterTimeScheduledNotifiationRecevied:"), name: NotificationsNames.tryingToPerformTaskAfterTimeScheduledNotifiationWithHiPriority, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("tryingToPerformTaskWithLowPriorityAfterTimeScheduledNotifiationRecevied:"), name: NotificationsNames.tryingToPerformTaskAfterTimeScheduledNotifiationWithLowPriority, object:nil)

    }
    
    func tryingToPerformTaskWithLowPriorityAfterTimeScheduledNotifiationRecevied(notification: NSNotification) {
        let task = notification.object as! Task
        self.presentNotificiationTryingToPerformTaskAfterTime(task)
    }
    
    func tryingToPerformTaskWithHiPriorityAfterTimeScheduledNotifiationRecevied(notification: NSNotification) {
        let task = notification.object as! Task
        self.presentNotificiationTryingToPerformTaskAfterTime(task)
    }
    
    func tryingToPerformTaskWithLowPriorityBeforeTimeScheduledNotifiationRecevied(notificiation : NSNotification) {
        if self.reminderPopUp.isPresented == true {
            return
        }
        let task = notificiation.object as! Task
        if task.taskisOnHold == true {
            return
        }
        self.presentNotificiationTryingToPerformTaskBeforeTimeWithPriorityLow(task)
    }

    func tryingToPerformTaskWithHiPriorityBeforeTimeScheduledNotifiationRecevied(notificiation : NSNotification) {
        if self.reminderPopUp.isPresented == true {
            return
        }
        let task = notificiation.object as! Task
        if task.taskisOnHold == true {
            return
        }
        self.presentNotificiationTryingToPerformTaskBeforeTimeWithPriorityHi(task)
    }
    
    internal func taskTimeNotification(notification : NSNotification) {
        if let localNotification = notification.object as? UILocalNotification {
            let key = ReminderSqueduler.TaskNotificationKey
            
            let majorAppendedByMinor = localNotification.userInfo![key] as? String
            let task = self.tasksServices.getTaskForMajorAppendedByMinorString(majorAppendedByMinor!)
            self .presentNotificiationTimeForTask(task)
        }
    }
    
//MARK:  Presentation
    
    func presentTaskIsOnHoldAndUserIsAtTheEreaPopUp(task : Task) {
        let taskVerificationPopUp = self.container.resolve(TaskVerificationPopUp.self, argument: task)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(taskVerificationPopUp!, animated: true, completion: nil)
    }
    
    func presentNotificiationTryingToPerformTaskAfterTime(task : Task) {
        let taskWarningPopUp = self.container.resolve(TaskWarningPopUp.self, argument: task)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(taskWarningPopUp!, animated: true, completion: nil)
    }

    func presentNotificiationTryingToPerformTaskBeforeTimeWithPriorityHi(task : Task) {
        let taskWarningPopUp = self.container.resolve(TaskWarningPopUp.self, argument: task)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(taskWarningPopUp!, animated: true, completion: nil)
    }

    func presentNotificiationTryingToPerformTaskBeforeTimeWithPriorityLow(task : Task) {
        let taskWarningPopUp = self.container.resolve(TaskWarningPopUp.self, argument: task)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(taskWarningPopUp!, animated: true, completion: nil)
    }

    func presentNotificiationTimeForTask(task : Task) {
        let notificationPopUp = self.container.resolve(TaskNotificationPopUp.self, argument: task)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        mainViewController?.presentViewController(notificationPopUp!, animated: true, completion: nil)
    }
    
    func presentTaskMarkedAsDone(task : Task) {
        let text = "Task has marked as done"
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task.taskBeaconIdentifier!, handler: { (result) -> Void in
                if (result == false) {
                } else {
                }
            })
        })
        
        reminderPopUp.presentPopUp(task.taskName!, message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in
            //
        })
    }
    
    //MARK: Actions
    
    func taskDone(task : Task) {
        self.tasksServices.removeTask(task)
    }
}