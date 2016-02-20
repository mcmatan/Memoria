//
//  NearTaskMonitor.swift
//  Memoria
//
//  Created by Matan Cohen on 2/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import UIKit

class NearTaskMonitor: NSObject {
    let maxTimeStandingNearTaskBeforeNotifyInSecounds = 5
    let tasksDB : TasksDB
    var identifiersForDateStartedToMonitor = Dictionary<String , NSDate>()
    
    init(tasksDB : TasksDB) {
        self.tasksDB = tasksDB
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("beaconIsNearMoreThenXTimeNotificationReceived:"), name: NotificationsNames.beaconsThatAreNearNotification, object: nil)
    }
    
    func beaconIsNearMoreThenXTimeNotificationReceived(notification :NSNotification) {
        let beacons = notification.object as! [CLBeacon]
        if beacons.count == 0 {
            self.identifiersForDateStartedToMonitor.removeAll()
            return
        }
        let identifiers = self.getIbeaconMajorAppendedByMinorForBeacons(beacons)
        
        let identifiersThatNoLongerExistsAtMonitoring = self.getIdentifiersThatNoLongerExistsAtMonitoring(identifiers)
        
        self.identifiersForDateStartedToMonitor.removeValuesForKeys(identifiersThatNoLongerExistsAtMonitoring)
        
        let identifersMonitoredMoreThenXTime = self.getIdentifiersMonitoredMoreThenXTime()
        if identifersMonitoredMoreThenXTime.count > 0 {
            self.fireNotificationsForIdentifiers(identifersMonitoredMoreThenXTime)
        }
        
        let identifiersThatAreNewToMonitoring = self.getIdentifiersThatAreNewToMonitoring(identifiers)
        
        self.addNewIdentifiersToStartMonitoring(identifiersThatAreNewToMonitoring)
        
    }
    
    func fireNotificationsForIdentifiers(identifiers : Array<String>) {
        for identifer in identifiers {
            if self.tasksDB.isThereTaskForMajorAppendedByMinor(identifer) == true {
                let task = self.tasksDB.getTaskForIBeaconMajorAppendedByMinor(identifer)
                let now = NSDate()
                let aMinuteAgo = (now - 1.minutes)
                if aMinuteAgo.isGreaterThanDate(task.taskTime!) {
                    self.fireTryingPerformTaskBeforeTime(task)
                }
                if now.isGreaterThanDate(task.taskTime!) {
                 self.fireTryingPerformTaskAfterTime(task)
                }
            }
        }
    }
    
    func fireTryingPerformTaskAfterTime(task : Task) {
        if task.taskTimePriorityHi == true {
            let notification = NSNotification(name: NotificationsNames.tryingToPerformTaskAfterTimeScheduledNotifiationWithHiPriority, object: task)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        } else {
            let notification = NSNotification(name: NotificationsNames.tryingToPerformTaskAfterTimeScheduledNotifiationWithLowPriority, object: task)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
    
    func fireTryingPerformTaskBeforeTime(task : Task) {
        if task.taskTimePriorityHi == true {
            let notification = NSNotification(name: NotificationsNames.tryingToPerformTaskBeforeTimeScheduledNotifiationWithHiPriority, object: task)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        } else {
            let notification = NSNotification(name: NotificationsNames.tryingToPerformTaskBeforeTimeScheduledNotifiationWithLowPriority, object: task)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
    
    func getIdentifiersMonitoredMoreThenXTime()->Array<String> {
        var identifiersMonitoredMoreThenTime = Array<String>()
        let now = NSDate()
        for identifer in self.identifiersForDateStartedToMonitor.keys {
            let identiferDate = self.identifiersForDateStartedToMonitor[identifer]
            if identiferDate?.secoundsAgoFromDate(now) > self.maxTimeStandingNearTaskBeforeNotifyInSecounds {
                identifiersMonitoredMoreThenTime.append(identifer)
            }
        }
        return identifiersMonitoredMoreThenTime
    }
    
    func addNewIdentifiersToStartMonitoring(identifiersNewToMonitoring : Array<String>) {
        for identifer in identifiersNewToMonitoring {
            self.identifiersForDateStartedToMonitor[identifer] = NSDate()
        }
    }
    
    func getIdentifiersThatAreNewToMonitoring(currentIdentifiers : Array<String>)->Array<String> {
        var identifiersThatAreNewToMonitoring = Array<String>()
        for currentidentifier in currentIdentifiers {
            if let _ = self.identifiersForDateStartedToMonitor[currentidentifier] {
            } else {
                   identifiersThatAreNewToMonitoring.append(currentidentifier)
            }
        }
        return identifiersThatAreNewToMonitoring
    }
    
    func getIdentifiersThatNoLongerExistsAtMonitoring(currentidentifiers : Array<String>)->Array<String> {
        var noLongerExists = Array<String>()
        for oldMajorAppendedByMinor in self.identifiersForDateStartedToMonitor.keys {
            if currentidentifiers.contains(oldMajorAppendedByMinor) == false {
                    noLongerExists.append(oldMajorAppendedByMinor)
            }
        }
        return noLongerExists
    }

    
    func getIbeaconMajorAppendedByMinorForBeacons(beacons : [CLBeacon])->Array<String> {
        var majorAppendedMyMinorsInDistance = Array<String>()
        for beacon in beacons {
            let beaconIdentifier = IBeaconIdentifier.creatFromCLBeacon(beacon)
            majorAppendedMyMinorsInDistance.append(beaconIdentifier.majorAppendedByMinorString())
        }
        return majorAppendedMyMinorsInDistance
    }
}
