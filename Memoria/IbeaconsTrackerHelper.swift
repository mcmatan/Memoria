//
//  IbeaconLocationFinderHelper
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import KontaktSDK

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Double, power: Double) -> Double {
    return Double(pow(Double(radix), Double(power)))
}

class IbeaconsTrackerHelper {
    
    class func locationManagerStateToString(_ state : CLAuthorizationStatus) ->String {
        switch (state) {
        case CLAuthorizationStatus.notDetermined:
            return "CLAuthorizationStatus.Failed"
        case CLAuthorizationStatus.restricted:
            return "CLAuthorizationStatus.restricted"
        case CLAuthorizationStatus.denied:
            return "CLAuthorizationStatus.denied"
        case CLAuthorizationStatus.authorizedAlways:
            return "CLAuthorizationStatus.authorizedAlways"
        case CLAuthorizationStatus.authorizedWhenInUse:
            return "CLAuthorizationStatus.authorizedWhenInUse"
        }
    }
    
    class func proximityToString(proximetly: CLProximity)-> String {
        switch proximetly {
        case CLProximity.unknown:
            return "Unknown"
        case CLProximity.far:
            return "far"
        case CLProximity.immediate:
            return "immediate"
        case CLProximity.near:
            return "near"
        }
    }
    
    class func calculateAccuracy(txPower: Double ,  rssi: Double)->Double {
        if (rssi == 0) {
            return -1.0; // if we cannot determine accuracy, return -1.
        }
        
        let ratio = rssi*1.0/txPower;
        if (ratio < 1.0) {
            return ratio^^10
        }
        else {
            let accuracy =  (0.89976)*(ratio^^7.7095) + 0.111;
            return accuracy;
        }
    }
    
    
    class func printBeaconsInfo(beacons: [CLBeacon], region: CLBeaconRegion) {
        for beacon in beacons {
            self.printBeaconInfo(beacon: beacon, region: region)
        }
    }
    
    class func printBeaconInfo(beacon: CLBeacon, region: CLBeaconRegion) {
        let beaconIdString = "Did monitore beacon with Identifer = \(beacon.major) \(beacon.minor)"
        let CLProximity = "CLProximity = \(IbeaconsTrackerHelper.proximityToString(proximetly: beacon.proximity))"
        let accurecy = "accurecy = \(beacon.accuracy)"
        let rssi = "rssi = \(beacon.rssi)"
        print(beaconIdString)
        print(CLProximity)
        print(accurecy)
        print(rssi)
    }
    class func printBeaconInfo(_ beacon : CLBeacon) {
        print("IBeacon rssi = \(beacon.rssi) uuid  = \(beacon.proximityUUID) accurecy = \(beacon.accuracy)")
        switch (beacon.proximity) {
        case CLProximity.far:
            print("Distance Far for major = \(beacon.major) minor = \(beacon.minor)")
            break;
        case CLProximity.immediate:
            print("Distance Immediate for major = \(beacon.major) minor = \(beacon.minor)")
            break;
        case CLProximity.unknown:
            print("Distance Unknown for major = \(beacon.major) minor = \(beacon.minor)")
            break;
        case CLProximity.near:
            print("Distance Near for major = \(beacon.major) minor = \(beacon.minor)")
            break;
        }
        print("")
        print("")
        print("")
    }
 

    
}
