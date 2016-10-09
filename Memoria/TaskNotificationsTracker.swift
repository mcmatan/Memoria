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


class TaskNotificationsTracker : NSObject, IbeaconsTrackerDelegate, SchedulerDelegate {
    fileprivate let taskDB : TasksDB
    fileprivate let minTimeFromWarningToWarning = 1.5 // min
    fileprivate let timeFromTaskDoneToShowWarningWhenNear = 60 //Sec
    fileprivate let maxTimeStandingNearTaskBeforeAction = 10 //Sec
    fileprivate let timeForRecognisionThatPerformingTaskInSec = 10 // Sec
    fileprivate let onHoldIntervalIntilNextNotification = 60 * 5 // Sec
    fileprivate let minTimeFromVerificationToVerification = 30 // Sec
    fileprivate let scheduler : Scheduler
    fileprivate let ibeaconsTracker : IbeaconsTracker
    
    init(taskDB : TasksDB, scheduler : Scheduler, ibeaconsTracker : IbeaconsTracker) {
        self.taskDB = taskDB
        self.scheduler = scheduler
        self.ibeaconsTracker = ibeaconsTracker
        super.init()
        self.scheduler.delegate = self        
        self.ibeaconsTracker.delegate = self
    }
    
    //MARK: Public
    internal func notificationScheduledTime(_ task : Task) {
        if task.isTaskDone == false {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kPresentTaskNotification), object: task, userInfo: nil)
        }
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
                        print("Marking task as done, since standing near at task time")
                        self.verifyUserDoingTask(task!)
                    } else if task!.taskisOnHold == true {
                        print("Marking task as done, since standing near at task when on hold")
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kTaskDone), object: task, userInfo: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kPresentTaskMarkedAsDone), object: task, userInfo: nil)
    }
    
    internal func remindMeLater(_ task : Task) {
        task.taskisOnHold = true
        let taskIdentifier = task.taskBeaconIdentifier
        let delayTime = DispatchTime.now() + Double(Int64(Double(self.onHoldIntervalIntilNextNotification) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if let isTaskNotDeleted = self.taskDB.getTaskForIBeaconIdentifier(taskIdentifier!) {
                if isTaskNotDeleted.taskisOnHold == true {
                    self.notificationScheduledTime(task)
                }
            }
        }
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
        let nowPlusIntercal = (now + timeForRecognisionThatPerformingTaskInSec.seconds)
        let nowMinusInterval = (now - timeForRecognisionThatPerformingTaskInSec.seconds)
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
                print("Should show verification, but too close to the last one, will wait \(secoundFromLastVerificaion) secounds")
                return
            }
        }
        task.timeLastVerifyWasShow = now
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kPresentTaskVerification), object: task, userInfo: nil)
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
                    if Float(isTaskLastWarningShow.minutesFrom(now)) < Float(minTimeFromWarningToWarning) {
                        return
                    }
                }
                task.timeLastWarningWasShow = Date()
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationsNames.kPresentTaskWarning), object: task, userInfo: nil)
            }            
        }
    }
}
