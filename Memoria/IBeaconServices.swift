//
//  IBeaconServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class IBeaconServices {
    var nearableLocator : NearableLocator
    var tasksDB : TasksDB
    let beaconCloud: IBeaconCloudType
    
    init(nearableLocator : NearableLocator, tasksDB : TasksDB, beaconCloud: IBeaconCloudType) {
        self.nearableLocator = nearableLocator
        self.tasksDB = tasksDB
        self.beaconCloud = beaconCloud
    }
    
    func isThereNearableInErea(_ handler: (( _ result : Bool, _ beacon : ESTNearable?) -> Void)!) {
        nearableLocator.getClosestNearable({ nearable in
            if let _ = nearable {
                handler(true, nearable)
            } else {
                handler(false, nearable)
            }
        })
    }
    
    func isBeaconAlreadyHasATaskAssigned(_ nearable :ESTNearable)->Bool {
        return self.tasksDB.isThereTaskForNearableIdentifier(nearable.identifier)
    }
    
    func getBeaconColorFor(nearableIdentifer :String)->UIColor {
        return self.beaconCloud.getColorFor(nearableIdentifer: nearableIdentifer)
    }
}
