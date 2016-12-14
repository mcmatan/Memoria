//
//  StickerTracker.swift
//  TestingEstimote
//
//  Created by Matan Cohen on 09/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

protocol NearableStriggerManagerDelegate {
    func nearableStartedMoving(nearableIdentifer: String)
    func nearableStoppedMoving(nearableIdentifer: String)
}

class NearableStriggerManager: NSObject, ESTTriggerManagerDelegate  {
    var delegate: NearableStriggerManagerDelegate!
    let triggerManager = ESTTriggerManager()
    let dataBase: DataBase
    
    init(dataBase: DataBase) {
        self.dataBase = dataBase
        super.init()
        self.triggerManager.delegate = self
        self.registerForAllTasks()
    }
    
    func registerForAllTasks() {
        let tasks = self.dataBase.getAllTasks()
        let _ = tasks.map { task -> String in
            if task.hasSticker() {
                self.startTrackingForMotion(identifer: task.nearableIdentifer!)   
            }
            return task.nearableIdentifer!
        }
        
    }
    
    //MARK: API
    func startTrackingForMotion(identifer: String) {
        let rule2 = ESTMotionRule.motionStateEquals(
            true, forNearableIdentifier: identifer)
        let trigger = ESTTrigger(rules: [rule2], identifier: identifer)
        self.triggerManager.startMonitoring(for: trigger)
        print("Started monitoring for movement nearable = \(identifer)")
    }
    
    func stopTrackingForMotion(identifer: String) {
        self.triggerManager.stopMonitoringForTrigger(withIdentifier: identifer)
        print("Stopped monitoring for movement nearable = \(identifer)")
    }
 
    //MARK: Delegate
    func triggerManager(_ manager: ESTTriggerManager,
                        triggerChangedState trigger: ESTTrigger) {
        if trigger.state == true {
            self.delegate.nearableStartedMoving(nearableIdentifer: trigger.identifier)
        } else {
         self.delegate.nearableStoppedMoving(nearableIdentifer: trigger.identifier)   
        }
    }


}
