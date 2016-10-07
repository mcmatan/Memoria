//
//  IBeaconIdentifier.swift
//  Memoria
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class IBeaconIdentifier : NSObject {
    let uuid : String
    let major : String
    let minor : String
    init(uuid : String, major : String, minor : String) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
    
    func majorAppendedByMinorString()->String {
        return self.major + self.minor
    }
    
    static func creatFromCLBeacon(_ cLBeacon : CLBeacon)->IBeaconIdentifier {
        return IBeaconIdentifier(uuid: cLBeacon.proximityUUID.uuidString, major: cLBeacon.major.stringValue, minor: cLBeacon.minor.stringValue)
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let uuid = aDecoder.decodeObject(forKey: "uuid") as! String
        let major = aDecoder.decodeObject(forKey: "major") as! String
        let minor = aDecoder.decodeObject(forKey: "minor") as! String
        self.init(uuid : uuid, major : major, minor : minor)
        
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(major, forKey: "major")
        aCoder.encode(minor, forKey: "minor")
    }
    
}
