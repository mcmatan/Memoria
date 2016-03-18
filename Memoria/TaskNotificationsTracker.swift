//
//  TaskNotificationsTracker.swift
//  Memoria
//
//  Created by Matan Cohen on 3/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class TaskNotificationsTracker : NSObject, IbeaconsTrackerDelegate, SchedulerDelegate {
    private let taskDB : TasksDB
    private let minTimeFromWarningToWarning = 3 // min
    private let timeFromTaskDoneToShowWarningWhenNear = 60 //Sec
    private let maxTimeStandingNearTaskBeforeAction = 10 //Sec
    private let timeForRecognisionThatPerformingTaskInSec = 10 // Sec
    private let onHoldIntervalIntilNextNotification = 60 * 5 // Sec
    private let scheduler : Scheduler
    private let ibeaconsTracker : IbeaconsTracker
    
    init(taskDB : TasksDB, scheduler : Scheduler, ibeaconsTracker : IbeaconsTracker) {
        self.taskDB = taskDB
        self.scheduler = scheduler
        self.ibeaconsTracker = ibeaconsTracker
        super.init()
        self.scheduler.delegate = self        
        self.ibeaconsTracker.delegate = self
    }
    
    //MARK: Public
    internal func notificationScheduledTime(task : Task) {
        if task.isTaskDone == false {
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationsNames.TaskTimeNotification, object: task, userInfo: nil)
        }
    }
    
    //Things that can happen when standing near task:
    //1.update standing near.
    //2.should perform task as this time.
    //3.task was on hold.
    //4.warn user for standing near task not at his time, if hi priority.
    internal func beaconInErea(beacon : CLBeacon) {
        var task = self.taskDB.getTaskForCLBeacn(beacon)
            if let _ = task {
                task = self.addOrUpdateStandingNearFromDate(task!)
                let isStandingLongEnouth = self.isNearTaskLongEnouth(task!)
                if isStandingLongEnouth == true  {
                    if task!.isTaskDone == true {
                        self.taskWarning(task!)
                    } else if self.shouldPerformTaskNow(task!) == true {
                        self.markTaskAsDone(task!)
                    } else if task!.taskisOnHold == true {
                        self.markTaskAsDone(task!)
                    } else {
                        self.taskNotDoneAndStandingNear(task!)
                    }
                }
            }
    }
    
    internal func markTaskAsDone(task : Task) {
        task.isTaskDone = true
        self.scheduler.cancelReminderForTask(task)
        self.taskDB.saveTask(task)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationsNames.kTaskDone, object: task, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationsNames.kPresentTaskMarkedAsDone, object: task, userInfo: nil)
    }
    
    internal func remindMeLater(task : Task) {
        task.taskisOnHold = true
        let taskIdentifier = task.taskBeaconIdentifier
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(self.onHoldIntervalIntilNextNotification) * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if let isTaskNotDeleted = self.taskDB.getTaskForIBeaconIdentifier(taskIdentifier!) {
                if isTaskNotDeleted.taskisOnHold == true {
                    self.notificationScheduledTime(task)
                }
            }
        }
    }
    
    //MARK: Private
    
    //MARK: Standing near a beacon states
    
    private func isNearTaskLongEnouth(task : Task)->Bool {
        if let isDate = task.standingNearFromDate {
            let now = NSDate()
            if now.secondsFrom(isDate) > maxTimeStandingNearTaskBeforeAction {
                    return true
            }
        }
        return false
    }
    
    private func shouldPerformTaskNow(task : Task)->Bool {
        let now = NSDate()
        let nowPlusIntercal = (now + timeForRecognisionThatPerformingTaskInSec.seconds)
        let nowMinusInterval = (now - timeForRecognisionThatPerformingTaskInSec.seconds)
        if (task.taskTime <= nowPlusIntercal && task.taskTime >= nowMinusInterval) {
            return true
        }
        return false
    }
    
    private func addOrUpdateStandingNearFromDate(task : Task)->Task {
        if let _ = task.standingNearFromDate {
            return task
        } else {
            task.standingNearFromDate = NSDate()
            return task
        }
    }
    
    private func taskNotDoneAndStandingNear(task : Task) {
        if task.taskTimePriorityHi == true {
                if task.taskTime?.isInTheFuture() == true { // If the task in the future, warn user about not doing it now.
                self.taskWarning(task)
                } else { // If the task is at the past, and its not done. so let the user confiem he allready did.
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationsNames.kPresentTaskVerification, object: task, userInfo: nil)
            }
        } else {
            //TODO: :Push-Verification Early-Completion
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationsNames.kPresentTaskVerification, object: task, userInfo: nil)
        }
    }
    
    private func taskWarning(task : Task) {
        let now = NSDate()
        if (now.secondsFrom(task.taskTime!) > timeFromTaskDoneToShowWarningWhenNear
            ||
            now.secondsFrom(task.taskTime!) < -timeFromTaskDoneToShowWarningWhenNear
            ) {
            if task.taskTimePriorityHi == true {
                if let isTaskLastWarningShow = task.timeLastWarningWasShow {
                    let now = NSDate()
                    if isTaskLastWarningShow.minutesFrom(now) < minTimeFromWarningToWarning {
                        return
                    }
                }
                task.timeLastWarningWasShow = NSDate()
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationsNames.kPresentTaskWarning, object: task, userInfo: nil)
            }            
        }
    }
}