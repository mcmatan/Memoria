//
//  TaskNotificationsTracker.swift
//  Memoria
//
//  Created by Matan Cohen on 3/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import SwiftDate

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class TaskNotificationsTracker : NSObject, NearableStriggerManagerDelegate {
    fileprivate let taskDB : TasksDB
    fileprivate let shouldPerformTaskTimeWindow = 60 * 5 // Sec
    fileprivate let scheduler : NotificationScheduler
    fileprivate let nearableStriggerManager : NearableStriggerManager
    
    
    init(taskDB : TasksDB, scheduler : NotificationScheduler, nearableStriggerManager : NearableStriggerManager) {
        self.taskDB = taskDB
        self.scheduler = scheduler
        self.nearableStriggerManager = nearableStriggerManager
        super.init()
        self.nearableStriggerManager.delegate = self
    }
    
    func nearableStartedMoving(nearableIdentifer: String) {
        let task = self.taskDB.getTaskForNearableIdentifer(nearableIdentifer)
        if let _ = task {
                if task!.isTaskDone == true {
                    print("Task allready done, and standing near")
                    self.taskWarning(task!)
                } else if self.shouldPerformTaskNow(task!) == true {
                    print("Asking if doing task, since standing near at task time")
                    self.showVerification(task!)
                } else {
                    print("Task not done and standing near")
                    self.taskNotDoneAndStandingNear(task!)
                }
        }
    }
    
    func nearableStoppedMoving(nearableIdentifer: String) {
        
    }
    
    internal func markTaskAsDone(_ task : Task) {
        task.isTaskDone = true
        self.scheduler.cancelReminderForTask(task)
        self.taskDB.saveTask(task)
        self.nearableStriggerManager.stopTrackingForMotion(identifer: task.nearableIdentifer)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kTaskDone), object: task, userInfo: nil)
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskMarkedAsDone, object: task, userInfo: nil)
    }
    
    //MARK: Private

    
    fileprivate func shouldPerformTaskNow(_ task : Task)->Bool {
        let now = Date()
        let nowPlusIntercal = (now + shouldPerformTaskTimeWindow.seconds)
        let nowMinusInterval = (now - shouldPerformTaskTimeWindow.seconds)
        if (task.taskTime <= nowPlusIntercal && task.taskTime >= nowMinusInterval) {
            return true
        }
        return false
    }
    
    fileprivate func taskNotDoneAndStandingNear(_ task : Task) {
        if task.taskTimePriorityHi == true {
                if task.taskTime?.isInTheFuture() == true { // If the task in the future, warn user about not doing it now.
                    print("Showing warning since stadning near not at time, and hi prioriry")
                self.taskWarning(task)
                } else { // If the task is at the past, and its not done. so let the user confiem he allready did.
                    print("If the task is at the past, and its not done. so let the user confiem he allready did.")
                self.showVerification(task)
            }
        } else {
            //TODO: :Push-Verification Early-Completion
            print("Showing verification")
            self.showVerification(task)
        }
    }
    
    fileprivate func showVerification(_ task : Task) {
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskVerification, object: task, userInfo: nil)
    }
    
    fileprivate func taskWarning(_ task : Task) {
        
        if task.taskTimePriorityHi == true {
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskWarning, object: task, userInfo: nil)
        }
    }
}
