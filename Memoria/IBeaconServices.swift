//
//  IBeaconServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class IBeaconServices {
    var ibeaconLocationFinder : IbeaconsTracker
    var tasksDB : TasksDB
    
    init(ibeaconLocationFinder : IbeaconsTracker, tasksDB : TasksDB) {
        self.ibeaconLocationFinder = ibeaconLocationFinder
        self.tasksDB = tasksDB
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
}
