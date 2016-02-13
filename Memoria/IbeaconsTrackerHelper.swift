//
//  IbeaconLocationFinderHelper
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class IbeaconsTrackerHelper {

    class func locationManagerStateToString(state : KTKLocationManagerState) ->String {
        switch (state) {
        case KTKLocationManagerState.Failed:
            return "KTKLocationManagerState.Failed"
        case KTKLocationManagerState.Inactive:
            return "KTKLocationManagerState.Inactive"
        case KTKLocationManagerState.Initializing:
            return "KTKLocationManagerState.Initializing"
        case KTKLocationManagerState.Monitoring:
            return "KTKLocationManagerState.Monitoring"
        }
    }
}