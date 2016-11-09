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
    
    override init() {
        super.init()
        self.triggerManager.delegate = self
    }
    
    //MARK: API
    func startTrackingForMotion(identifer: String) {
        let rule2 = ESTMotionRule.motionStateEquals(
            true, forNearableIdentifier: identifer)
        let trigger = ESTTrigger(rules: [rule2], identifier: identifer)
        self.triggerManager.startMonitoring(for: trigger)
    }
    
    func stopTrackingForMotion(identifer: String) {
        self.triggerManager.stopMonitoringForTrigger(withIdentifier: identifer)
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
