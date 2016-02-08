//
//  TasksNotifications.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
class TasksNotificationsTracker : NSObject  {
    var tasksDB : TasksDB
    var isPresentingMessage = false
    
    init(tasksDB : TasksDB) {
        self.tasksDB = tasksDB
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("beaconIsNearNotification:"), name: NotificationsNames.beaconIsNearNotification, object: nil)
    }

    internal func beaconIsNearNotification(notification : NSNotification) {
        if let isBeacon = notification.object {
            let ibeaconIdentifier = IBeaconIdentifier.creatFromCLBeacon(isBeacon as! CLBeacon)
            if (self.tasksDB.isThereTaskForIBeaconIdentifier(ibeaconIdentifier)) {
                let task = self.tasksDB.getTaskForIBeaconIdentifier(ibeaconIdentifier)
                self.presentQuestionIsUserCurrentlyDoingTask(task)
            }
        }
    }
    
    func presentQuestionIsUserCurrentlyDoingTask(task : Task) {
        
        if self.isPresentingMessage == true {
            return
        }
        self.isPresentingMessage = true
        
        var text = ""
        if let isTaskName = task.taskName {
            text = "Are you currently doing task: \(isTaskName)?"
        }

        let alert = UIAlertController(title: text, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let actionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (alert) -> Void in
            self.isPresentingMessage = false
        }
        let actionNo = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (alert) -> Void in
            self.isPresentingMessage = false
        }
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
      //  mainViewController?.presentViewController(alert, animated: true, completion: nil)

    }
}