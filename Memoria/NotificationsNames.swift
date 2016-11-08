//
//  NotificationsNames.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class NotificationsNames {
    static let enterdAreaWithActiveTeskNotification = "enterdAreaWithActiveTesk" //Holdes task
    static let beaconsThatAreNearNotification = "beaconIsNear" // Holdes CLBeacon Array

    static let NotificationDidOccur = "NotificationDidOccur"
    
    static let kTaskDone = "TaskDone"

    static let kPresentTaskNotification = Notification.Name(rawValue: "presentTaskNotification")
    static let kPresentTaskVerification = Notification.Name(rawValue: "presentTaskVerification")
    static let kPresentTaskWarning = Notification.Name(rawValue: "presentTaskWarning")
    static let kPresentTaskMarkedAsDone = Notification.Name(rawValue: "presentTaskMarkedAsDone")
    
    static let ConfirmTaskNotification = Notification.Name(rawValue: "ConfirmTaskNotification")
    
    
    //All will pass "Task" Object"
    static let kTask_Action_playSound = Notification.Name(rawValue: "kTask_Action_playSound")  //WillPassTask
    static let kTask_Action_markAsDone = Notification.Name(rawValue: "kTask_Action_markAsDone") //WillPassTask
    static let kTask_Action_Snooze = Notification.Name(rawValue: "kTask_Action_Snooz") //WillPassTask
}
