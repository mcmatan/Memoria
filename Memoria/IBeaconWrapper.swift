//
//  IBeaconWrapper.swift
//  Memoria
//
//  Created by Matan Cohen on 08/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class IBeaconWrapper: NSObject, ESTBeaconManagerDelegate {
    let beaconManager = ESTBeaconManager()

    override init() {
        super.init()
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization() // Location for the app also when in background
        self.beaconManager.startMonitoring(for: CLBeaconRegion(
            proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID,
            major: 58227, minor: 39732, identifier: "6e00185bd93bb636c15d2b54e7e4ad09"))
        
    }
    
    //ESTBeaconManagerDelegate
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        let notification = UILocalNotification()
        notification.alertBody =
            "Your gate closes in 47 minutes. " +
            "Current security wait time is 15 minutes, " +
            "and it's a 5 minute walk from security to the gate. " +
        "Looks like you've got plenty of time!"
        UIApplication.shared.presentLocalNotificationNow(notification)
        print(#function)
    }
    func beaconManager(_ manager: Any, didFailWithError error: Error) {
        print(#function)
    }
    func beaconManagerDidStartAdvertising(_ manager: Any, error: Error?) {
        print(#function)
    }
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print(#function)
    }
    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
        print(#function)
    }
    func beaconManager(_ manager: Any, didStartMonitoringFor region: CLBeaconRegion) {
        print("\(#function) details = \(region.major) \(region.minor)")
    }
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(#function)
    }
    func beaconManager(_ manager: Any, didDetermineState state: CLRegionState, for region: CLBeaconRegion) {
        print(#function)
    }
    func beaconManager(_ manager: Any, monitoringDidFailFor region: CLBeaconRegion?, withError error: Error) {
        print(#function)
    }
    func beaconManager(_ manager: Any, rangingBeaconsDidFailFor region: CLBeaconRegion?, withError error: Error) {
        print(#function)
    }
    
}
