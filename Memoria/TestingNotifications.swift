//
//  TestingNotifications.swift
//  Memoria
//
//  Created by Matan Cohen on 08/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
let shouldTest = true

class TestingNotifications {
    var timer = Timer()
    let repeatTimeInterval = 7.0
    let localNotificationScheduler: LocalNotificationScheduler
    
    init(localNotificationScheduler: LocalNotificationScheduler) {
        self.localNotificationScheduler = localNotificationScheduler
        if (shouldTest == false) {
            return
        }
//        self.startShowingDrugsNotifications()
        //self.startShowingDrugsVerification()
        //self.startShowingDrugsWarning()
    }
    
    //App is not active (local notifications)
    
    //Warning:
    
    func startShowingDrugsWarning() {
        self.timer = Timer.scheduledTimer(timeInterval: repeatTimeInterval, target: self, selector: #selector(TestingNotifications.showSingleGrugWarning), userInfo: nil, repeats: true)
    }
    
    @objc func showSingleGrugWarning() {
        let task = Task(taskType: TaskType.drugs, taskTime: Date(), nearableIdentifer: "", taskTimePriorityHi: true)
        
        self.localNotificationScheduler.scheduleLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.warning)
    }
    
    //Verification:
    
    func startShowingDrugsVerification() {
        self.timer = Timer.scheduledTimer(timeInterval: repeatTimeInterval, target: self, selector: #selector(TestingNotifications.showSingleGrugVerification), userInfo: nil, repeats: true)
    }
    
    @objc func showSingleGrugVerification() {
        let task = Task(taskType: TaskType.drugs, taskTime: Date(), nearableIdentifer:"", taskTimePriorityHi: true)
        
        self.localNotificationScheduler.scheduleLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.verification)
    }
    
    //Notification 
    
    func startShowingDrugsNotifications() {
        self.timer = Timer.scheduledTimer(timeInterval: repeatTimeInterval, target: self, selector: #selector(TestingNotifications.showSingleGrugNotification), userInfo: nil, repeats: true)
    }
    
    @objc func showSingleGrugNotification() {
        let task = Task(taskType: TaskType.drugs, taskTime: Date(), nearableIdentifer: "", taskTimePriorityHi: true)
        
        self.localNotificationScheduler.scheduleLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.notification)
    }
}
