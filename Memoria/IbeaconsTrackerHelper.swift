//
//  IbeaconLocationFinderHelper
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import KontaktSDK

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
}
