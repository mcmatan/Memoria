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
    
    static func creatFromCLBeacon(cLBeacon : CLBeacon)->IBeaconIdentifier {
        return IBeaconIdentifier(uuid: cLBeacon.proximityUUID.UUIDString, major: cLBeacon.major.stringValue, minor: cLBeacon.minor.stringValue)
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let uuid = aDecoder.decodeObjectForKey("uuid") as! String
        let major = aDecoder.decodeObjectForKey("major") as! String
        let minor = aDecoder.decodeObjectForKey("minor") as! String
        self.init(uuid : uuid, major : major, minor : minor)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeObject(major, forKey: "major")
        aCoder.encodeObject(minor, forKey: "minor")
    }
    
}