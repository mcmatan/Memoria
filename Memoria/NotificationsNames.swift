//
//  NotificationsNames.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import EmitterKit


class NotificationsNames {
    
    static let kTaskDone = "TaskDone"
    
    static let kPresentTaskNotification = Notification.Name(rawValue: "presentTaskNotification")
    static let kPresentTaskVerification = Notification.Name(rawValue: "presentTaskVerification")
    static let kPresentTaskWarning = Notification.Name(rawValue: "presentTaskWarning")
    static let kPresentTaskMarkedAsDone = Notification.Name(rawValue: "presentTaskMarkedAsDone")
    
    
    //All will pass "Task" Object"
    static let kTask_Action_playSound = Notification.Name(rawValue: "kTask_Action_playSound")  //WillPass TaskActionDTO
    static let kTask_Action_markAsDone = Notification.Name(rawValue: "kTask_Action_markAsDone") //WillPass TaskActionDTO
    static let kTask_Action_Snooze = Notification.Name(rawValue: "kTask_Action_Snooz") //WillPass TaskActionDTO
}

struct TaskActionDTO {
    let task: Task
    let localNotificationCategort: LocalNotificationCategotry
}

class Events {
    static let shared = Events()
    
    
    let loginSuccess = Event<Any>()
    let logout = Event<Any>()
}
