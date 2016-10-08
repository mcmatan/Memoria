//
//  IBeaconWrapper.swift
//  Memoria
//
//  Created by Matan Cohen on 08/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class IBeaconWrapper: NSObject, ESTBeaconManagerDelegate {
    let beaconManager = ESTBeaconManager()

    override init() {
        super.init()
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization() // Location for the app also when in background
        self.beaconManager.startMonitoring(for: CLBeaconRegion(
            proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID,
            major: 58227, minor: 39732, identifier: "monitored region"))
        
    }
    
    //ESTBeaconManagerDelegate
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        //
    }
    func beaconManager(_ manager: Any, didFailWithError error: Error) {
        //
    }
    func beaconManagerDidStartAdvertising(_ manager: Any, error: Error?) {
        //
    }
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        //
    }
    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
        //
    }
    func beaconManager(_ manager: Any, didStartMonitoringFor region: CLBeaconRegion) {
        //
    }
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //
    }
    func beaconManager(_ manager: Any, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        //
    }
    func beaconManager(_ manager: Any, monitoringDidFailFor region: CLBeaconRegion?, withError error: Error) {
        //
    }
    func beaconManager(_ manager: Any, rangingBeaconsDidFailFor region: CLBeaconRegion?, withError error: Error) {
        //
    }
    
}
