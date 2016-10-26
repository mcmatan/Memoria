//
//  CLBeaconExtentions.swift
//  Memoria
//
//  Created by Matan Cohen on 25/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

extension CLBeacon {
    func isEqualToBeacon(beacon: CLBeacon)->Bool {
        let major = beacon.minor == self.minor
        let minor = beacon.major == self.major
        let uuid = beacon.proximityUUID == self.proximityUUID
        return (((uuid == true && minor == true) && major == true))
    }
}
