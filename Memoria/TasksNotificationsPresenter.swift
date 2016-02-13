//
//  TasksNotificationsPresenter.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class TasksNotificationsPresenter : NSObject {
    let tasksServices : TasksServices
    let iBeaconServices : IBeaconServices
    let recorder : VoiceRecorder
    
    init(tasksServices : TasksServices, iBeaconServices : IBeaconServices) {
        self.tasksServices = tasksServices
        self.iBeaconServices = iBeaconServices
        self.recorder = VoiceRecorder()
        
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("taskTimeNotification:"), name: NotificationsNames.TaskTimeNotification, object:nil)
    }
    
    
    internal func taskTimeNotification(notification : NSNotification) {
        if let localNotification = notification.object as? UILocalNotification {
            let key = ReminderSqueduler.TaskNotificationKey
            
            print(localNotification.userInfo![key])
            let majorAppendedByMinor = localNotification.userInfo![key] as? String
            let task = self.tasksServices.getTaskForMajorAppendedByMinorString(majorAppendedByMinor!)
            self .presentNotificiationForTask(task)
        }
    }

    func presentNotificiationForTask(task : Task) {
        self.recorder .setURLToPlayFrom(task.taskVoiceURL!)
        self.recorder.play()
        let text = "You have a task names: \(task.taskName!) for now."
        let reminderPopUp = ReminderPopUp()
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task.taskBeaconIdentifier!, handler: { (result) -> Void in
                if (result == false) {
                        self.presentNotificationTryingToPressOkWhenNotInTheErea(task)
                } else {
                        self.taskDone(task)
                }
            })
        })
        reminderPopUp.presentPopUp(task.taskName!, message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in
            //
        })
    }
    
    func presentNotificationTryingToPressOkWhenNotInTheErea(task : Task) {
        self.recorder .setURLToPlayFrom(task.taskVoiceURL!)
        self.recorder.play()
        let text = "Sorry you dont seem to be at the erea of: \(task.taskName!) task. Please go to \(task.taskName!) ans press ok"
        let reminderPopUp = ReminderPopUp()
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task.taskBeaconIdentifier!, handler: { (result) -> Void in
                if (result == false) {
                    self.presentNotificationTryingToPressOkWhenNotInTheErea(task)
                } else {
                    self.taskDone(task)
                }
            })
        })
        reminderPopUp.presentPopUp(task.taskName!, message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in
            //
        })
    }
    
    func taskDone(task : Task) {
        self.tasksServices.removeTask(task)
    }
}