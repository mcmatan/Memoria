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
        
        var ratio = rssi*1.0/txPower;
        if (ratio < 1.0) {
            return ratio^^10
        }
        else {
            var accuracy =  (0.89976)*(ratio^^7.7095) + 0.111;
            return accuracy;
        }
    }
    
 

    
}
