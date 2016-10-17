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
    var ibeaconLocationFinder : IbeaconsTracker
    var tasksDB : TasksDB
    let beaconCloud: IBeaconCloudType
    
    init(ibeaconLocationFinder : IbeaconsTracker, tasksDB : TasksDB, beaconCloud: IBeaconCloudType) {
        self.ibeaconLocationFinder = ibeaconLocationFinder
        self.tasksDB = tasksDB
        self.beaconCloud = beaconCloud
    }
    
    func isThereABeaconInArea(_ handler: (( _ result : Bool, _ beacon : CLBeacon?) -> Void)!) {
        return self.ibeaconLocationFinder.isThereABeaconInArea(handler)
    }
    
    internal func isBeaconInErea(_ iBeaconIdentifier : IBeaconIdentifier , handler: (( _ result : Bool) -> Void)!) {
        return self.ibeaconLocationFinder.isBeaconInErea(iBeaconIdentifier, handler: handler)
    }
    
    func isBeaconAlreadyHasATaskAssigned(_ beacon :CLBeacon)->Bool {
        let closestIBeacon = beacon
        return self.tasksDB.isThereTaskForIBeaconIdentifier(IBeaconIdentifier.creatFromCLBeacon(closestIBeacon))
    }
    
    func getBeaconColorFor(beaconIdentifier :IBeaconIdentifier)->UIColor {
        return self.beaconCloud.getColorFor(beaconIdentifier: beaconIdentifier)
    }
}
