//
//  IbeaconLocationFinderHelper
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class IbeaconsTrackerHelper {

    class func locationManagerStateToString(_ state : KTKLocationManagerState) ->String {
        switch (state) {
        case KTKLocationManagerState.failed:
            return "KTKLocationManagerState.Failed"
        case KTKLocationManagerState.inactive:
            return "KTKLocationManagerState.Inactive"
        case KTKLocationManagerState.initializing:
            return "KTKLocationManagerState.Initializing"
        case KTKLocationManagerState.monitoring:
            return "KTKLocationManagerState.Monitoring"
        }
    }
}
