//
//  NearableLocator.swift
//  TestingEstimote
//
//  Created by Matan Cohen on 09/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UserNotifications

class NearableLocator:NSObject, ESTNearableManagerDelegate {
    let nearableManager = ESTNearableManager()
    var closeNearable: ESTNearable?
    let searchForNearableDelayTime = 2.0
    
    override init() {
        self.nearableManager.startRanging(for: ESTNearableType.all)
        super.init()
        self.nearableManager.delegate = self
    }
    
    //MARK: API
    internal func getClosestNearable(_ handler: ((_ nearable: ESTNearable?) -> Void)!) {
        let delayTime = DispatchTime.now() + Double(Int64(self.searchForNearableDelayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            handler(self.closeNearable)
        }
    }
    
    func getClosestNearable()->ESTNearable? {
        return self.closeNearable
    }
    
    //MARK: Delegate
    func nearableManager(_ manager: ESTNearableManager, rangingFailedWithError error: Error) {
        print("rangingFailedWithError \(error)")
    }
    
    func nearableManager(_ manager: ESTNearableManager, didRangeNearables nearables: [ESTNearable], with type: ESTNearableType) {
        self.closeNearable = nil
        for nearable in nearables {
            if nearable.zone() == ESTNearableZone.immediate {
                self.closeNearable = nearable
            }
        }
    }
}
