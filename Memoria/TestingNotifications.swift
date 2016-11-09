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
    
    init() {
        if (shouldTest == false) {
            return
        }
        //self.startShowingDrugsNotifications()
        //self.startShowingDrugsVerification()
        //self.startShowingDrugsWarning()
    }
    
    //App is not active (local notifications)
    
    //Warning:
    
    func startShowingDrugsWarning() {
        self.timer = Timer.scheduledTimer(timeInterval: repeatTimeInterval, target: self, selector: #selector(TestingNotifications.showSingleGrugWarning), userInfo: nil, repeats: true)
    }
    
    @objc func showSingleGrugWarning() {
        let task = Task(taskType: TaskType.drugs, taskTime: Date(), taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""), taskTimePriorityHi: true)
        
        LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.warning)
    }
    
    //Verification:
    
    func startShowingDrugsVerification() {
        self.timer = Timer.scheduledTimer(timeInterval: repeatTimeInterval, target: self, selector: #selector(TestingNotifications.showSingleGrugVerification), userInfo: nil, repeats: true)
    }
    
    @objc func showSingleGrugVerification() {
        let task = Task(taskType: TaskType.drugs, taskTime: Date(), taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""), taskTimePriorityHi: true)
        
        LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.verification)
    }
    
    //Notification 
    
    func startShowingDrugsNotifications() {
        self.timer = Timer.scheduledTimer(timeInterval: repeatTimeInterval, target: self, selector: #selector(TestingNotifications.showSingleGrugNotification), userInfo: nil, repeats: true)
    }
    
    @objc func showSingleGrugNotification() {
        let task = Task(taskType: TaskType.drugs, taskTime: Date(), taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""), taskTimePriorityHi: true)
        
        LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.notification)
    }
    
    //App is active
    func presentTestNoficiationScreen() {
        
        let delayTime = DispatchTime.now() + Double(Int64(15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            
            
            //            let beaconIdentifier = IBeaconIdentifier(uuid: "124", major: "123", minor: "123")
            //            let date = Date() - 3.hours
            //            _ = Task(taskName: "להוציא את הכלב", taskTime: date, taskVoiceURL: URL(string: "www.google.com")!, taskBeaconIdentifier: beaconIdentifier, taskTimePriorityHi: true)
            //
            //            //            self.vc = Bootstrapper.container.resolve(TaskNotificationPopUp.self, argument: task)
            //            //            self.vc = Bootstrapper.container.resolve(TaskVerificationPopUp.self, argument: task)
            //            //            self.vc = Bootstrapper.container.resolve(TaskWarningPopUp.self, argument: task)
            //
            //            //            rootViewController!.presentViewController(self.vc, animated: true, completion: nil)
            //            
            //            AEConsole.launch(with: self)
            
            
        }
    }
}
