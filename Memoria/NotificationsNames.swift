//
//  NotificationsNames.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import EmitterKit

struct TaskActionDTO {
    let task: Task
}

class Events {
    static let shared = Events()
    
    let loginSuccess = Event<Any>()
    let logout = Event<Any>()
    let tasksChanged = Event<Any>()
    
    let presentTaskNotification = Event<Task>()
    let taskMarkedAsDone = Event<Task>()
    
    let playSound = Event<Task>()
    let markTaskAsDone = Event<Task>()
}
