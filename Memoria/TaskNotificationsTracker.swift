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


class TaskNotificationsTracker : NSObject, IbeaconsTrackerDelegate {
    fileprivate let taskDB : TasksDB
    fileprivate let shouldWaitForWarningToWarning = true
    fileprivate let secoundsTimeFromWarningToWarning = 30 //100 // Sec
    fileprivate let timeFromTaskDoneToShowWarningWhenNear = 20//60 //Sec
    fileprivate let maxTimeStandingNearTaskBeforeAction = 0//2 //Sec
    fileprivate let shouldPerformTaskTimeWindow = 60 * 5 // Sec
    fileprivate let onHoldIntervalIntilNextNotification = 0 // 60 * 5 // Sec
    fileprivate let minTimeFromVerificationToVerification = 25//30 // Sec
    fileprivate let scheduler : NotificationScheduler
    fileprivate let ibeaconsTracker : IbeaconsTracker
    
    
    init(taskDB : TasksDB, scheduler : NotificationScheduler, ibeaconsTracker : IbeaconsTracker) {
        self.taskDB = taskDB
        self.scheduler = scheduler
        self.ibeaconsTracker = ibeaconsTracker
        super.init()
        self.ibeaconsTracker.delegate = self
    }
    
    //Things that can happen when standing near task:
    //1.update standing near.
    //2.should perform task as this time.
    //3.task was on hold.
    //4.warn user for standing near task not at his time, if hi priority.
    internal func beaconInErea(_ beacon : CLBeacon) {
        var task = self.taskDB.getTaskForCLBeacn(beacon)
            if let _ = task {
                task = self.addOrUpdateStandingNearFromDate(task!)
                let isStandingLongEnouth = self.isNearTaskLongEnouth(task!)
                if isStandingLongEnouth == true  {
                    if task!.isTaskDone == true {
                        print("Task allready done, and standing near")
                        self.taskWarning(task!)
                    } else if self.shouldPerformTaskNow(task!) == true {
                        print("Asking if doing task, since standing near at task time")
                        self.verifyUserDoingTask(task!)
                    } else {
                        print("Task not done and standing near")
                        self.taskNotDoneAndStandingNear(task!)
                    }
                }
            }
    }
    
    internal func markTaskAsDone(_ task : Task) {
        task.isTaskDone = true
        self.scheduler.cancelReminderForTask(task)
        self.taskDB.saveTask(task)
        self.ibeaconsTracker.unRegisterForBeacon(uuid: (task.taskBeaconIdentifier?.uuid)!, major: (task.taskBeaconIdentifier?.major)!, minor: (task.taskBeaconIdentifier?.minor)!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kTaskDone), object: task, userInfo: nil)
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskMarkedAsDone, object: task, userInfo: nil)
    }
    
    //MARK: Private
    
    //MARK: Standing near a beacon states
    
    fileprivate func isNearTaskLongEnouth(_ task : Task)->Bool {
        if let isDate = task.standingNearFromDate {
            let now = Date()
            if now.secondsFrom(isDate) > maxTimeStandingNearTaskBeforeAction {
                    return true
            }
        }
        return false
    }
    
    fileprivate func shouldPerformTaskNow(_ task : Task)->Bool {
        let now = Date()
        let nowPlusIntercal = (now + shouldPerformTaskTimeWindow.seconds)
        let nowMinusInterval = (now - shouldPerformTaskTimeWindow.seconds)
        if (task.taskTime <= nowPlusIntercal && task.taskTime >= nowMinusInterval) {
            return true
        }
        return false
    }
    
    fileprivate func addOrUpdateStandingNearFromDate(_ task : Task)->Task {
        if let _ = task.standingNearFromDate {
            return task
        } else {
            task.standingNearFromDate = Date()
            return task
        }
    }
    
    fileprivate func taskNotDoneAndStandingNear(_ task : Task) {
        if task.taskTimePriorityHi == true {
                if task.taskTime?.isInTheFuture() == true { // If the task in the future, warn user about not doing it now.
                    print("Showing warning since stadning near not at time, and hi prioriry")
                self.taskWarning(task)
                } else { // If the task is at the past, and its not done. so let the user confiem he allready did.
                    print("If the task is at the past, and its not done. so let the user confiem he allready did.")
                self.verifyUserDoingTask(task)
            }
        } else {
            //TODO: :Push-Verification Early-Completion
            print("Showing verification")
            self.verifyUserDoingTask(task)
        }
    }
    
    fileprivate func verifyUserDoingTask(_ task : Task) {
        let now = Date()
        if let isTaskTimeLastVerifyWasShow = task.timeLastVerifyWasShow {
            let secoundFromLastVerificaion = abs(Float(isTaskTimeLastVerifyWasShow.secondsFrom(now)))
            if secoundFromLastVerificaion < Float(minTimeFromVerificationToVerification) {
                print("Should show verification, but too close to the last one, will wait \(Float(minTimeFromVerificationToVerification) - secoundFromLastVerificaion) secounds")
                return
            }
        }
        task.timeLastVerifyWasShow = now
        NotificationCenter.default.post(name: NotificationsNames.kPresentTaskVerification, object: task, userInfo: nil)
    }
    
    fileprivate func taskWarning(_ task : Task) {
        let now = Date()
        if (now.secondsFrom(task.taskTime!) > timeFromTaskDoneToShowWarningWhenNear
            ||
            now.secondsFrom(task.taskTime!) < -timeFromTaskDoneToShowWarningWhenNear
            ) {
            if task.taskTimePriorityHi == true {
                if let isTaskLastWarningShow = task.timeLastWarningWasShow {
                    let now = Date()
                    
                    let lastStanding = Float(isTaskLastWarningShow.secondsFrom(now))
                    let secoundsNear = Float(secoundsTimeFromWarningToWarning)
                    if ((-lastStanding < secoundsNear)
                    && (self.shouldWaitForWarningToWarning == true )){
                        return
                    }
                }
                task.timeLastWarningWasShow = Date()
                NotificationCenter.default.post(name: NotificationsNames.kPresentTaskWarning, object: task, userInfo: nil)
            }            
        }
    }
}
