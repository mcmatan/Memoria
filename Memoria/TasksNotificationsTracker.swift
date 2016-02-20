//
//  TasksNotificationsPresenter.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class TasksNotificationsTracker : NSObject {
    let tasksServices : TasksServices
    let iBeaconServices : IBeaconServices
    let recorder : VoiceRecorder
    let reminderPopUp = ReminderPopUp()
    
    init(tasksServices : TasksServices, iBeaconServices : IBeaconServices) {
        self.tasksServices = tasksServices
        self.iBeaconServices = iBeaconServices
        self.recorder = VoiceRecorder()
        
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
            
            print(localNotification.userInfo![key])
            let majorAppendedByMinor = localNotification.userInfo![key] as? String
            let task = self.tasksServices.getTaskForMajorAppendedByMinorString(majorAppendedByMinor!)
            self .presentNotificiationTimeForTask(task)
        }
    }
    
//MARK:  Presentation
    
    func presentTaskIsOnHoldAndUserIsAtTheEreaPopUp(task : Task) {
        let text = "Are you currently performing the task \(task.taskName), If not please do and press ok"
        let okButton = ButtonAction(title: "Ok") { (ButtonAction) -> Void in
            self.taskDone(task)
        }
        let cancelButton = ButtonAction(title: "Cancel", handler: { (ButtonAction) -> Void in

        })
        reminderPopUp.presentPopUp(task.taskName!, message: text, cancelButton: cancelButton, buttons: [okButton], completion: { () -> Void in
            //
        })
    }
    
    func presentNotificiationTryingToPerformTaskAfterTime(task : Task) {
        let text = "Trying to perform The task \(task.taskName!) after its time.  Its for \(task.taskTime!.toStringWithCurrentRegion()) not for now."
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

    func presentNotificiationTryingToPerformTaskBeforeTimeWithPriorityHi(task : Task) {
        let taskName = task.taskName!
        let taskTime = task.taskTime!.toStringWithCurrentRegion()
        let text = "Your trying to perform the task : \(taskName).\n bofre its time, that is: \(taskTime)"
        
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

    
    func presentNotificiationTryingToPerformTaskBeforeTimeWithPriorityLow(task : Task) {
        let taskName = task.taskName!
        let taskTime = task.taskTime!.toStringWithCurrentRegion()
        let text = "Your trying to perform the task : \(taskName).\n before its time, that is: \(taskTime)"
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task.taskBeaconIdentifier!, handler: { (result) -> Void in
                if (result == false) {
                } else {
                }
            })
        })
        
        let markTaskAsDone = ButtonAction(title: "Mark as task as done") { (ButtonAction) -> Void in
            self.tasksServices.removeTask(task)
            self.presentTaskMarkedAsDone(task)
        }
        reminderPopUp.presentPopUp(task.taskName!, message: text, cancelButton: cancelButton, buttons: [markTaskAsDone], completion: { () -> Void in
            //
        })
    }
    

    func presentNotificiationTimeForTask(task : Task) {
        
        self.recorder .setURLToPlayFrom(task.taskVoiceURL!)
        self.recorder.play()
        let text = "You have a task names: \(task.taskName!) for now."
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task.taskBeaconIdentifier!, handler: { (result) -> Void in
                if (result == false) {
                    self.tasksServices.setTaskIsOnHold(task)
                } else {
                        self.taskDone(task)
                }
            })
        })
        reminderPopUp.presentPopUp(task.taskName!, message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in
            //
        })
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