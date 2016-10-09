import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


protocol IbeaconsTrackerDelegate {
    func beaconInErea(_ clBeacon : CLBeacon)
}

class IbeaconsTracker : NSObject  , ESTBeaconManagerDelegate {
    var delegate : IbeaconsTrackerDelegate?
    let minimunDistanceToBeacon = 1.3 //In miters
    let searchForBeaconDelayTime = 2.0
    let beaconManager = ESTBeaconManager()
    var currentClosesBeacon : CLBeacon?
    var beaconsInErea : [CLBeacon]?
    
    override init() {
        super.init()
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization() // Location for the app also when in background
        
        
        let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        self.beaconManager.startRangingBeacons(in: CLBeaconRegion(proximityUUID: uuid!, identifier: "6e00185bd93bb636c15d2b54e7e4ad09"))
        
        if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.available {
            print("Background updates are available for the app.")
        }else if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.denied
        {
            print("The user explicitly disabled background behavior for this app or for the whole system.")
        }else if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.restricted
        {
            print("Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.")
        }
        
    }
    
    internal func StopMonitoring() {
        self.beaconManager.stopMonitoringForAllRegions()
    }
    
    
    internal func isThereABeaconInArea(_ handler: (( _ result : Bool, _ beacon : CLBeacon?) -> Void)!) {
        self.currentClosesBeacon = nil
        let delayTime = DispatchTime.now() + Double(Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if let _ = self.currentClosesBeacon {
                handler(true, self.currentClosesBeacon)
            } else {
                handler(false, nil)
            }
        }
    }
    
    internal func isBeaconInErea(_ iBeaconIdentifier : IBeaconIdentifier , handler: (( _ result : Bool) -> Void)!) {
        self.beaconsInErea = []
        let delayTime = DispatchTime.now() + Double(Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            var isExists = false
            if let isBeaconsInErea = self.beaconsInErea {
                for beacon in isBeaconsInErea {
                    let currenctBeaconIdentifer = IBeaconIdentifier.creatFromCLBeacon(beacon)
                    if currenctBeaconIdentifer.majorAppendedByMinorString() == iBeaconIdentifier.majorAppendedByMinorString() {
                        isExists = true
                    }
                }
                handler((isExists))
            } else {
                handler((false))
            }
        }
        
    }
    
    //MARK: Private
    //MARK: LocationManagerDelegate
    
    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
        print(IbeaconsTrackerHelper.locationManagerStateToString(status))
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.beaconsInErea?.removeAll()
        
        let onlyCloseBeacons = self.getOnlyCloseBeacons(beacons)
        self.beaconsInErea = onlyCloseBeacons
        self.beaconIsNear(onlyCloseBeacons)
        
        print("Ranged Close count: \(onlyCloseBeacons.count)")
        print("Ranged beacons count: \(beacons.count)")
        if ((beacons.count > 0) == false) {
            return
        }
        let beacon = self.getClosestBeacon(beacons)
        if beacon?.accuracy < self.minimunDistanceToBeacon {
            self.currentClosesBeacon = beacon
        }
        
    }
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("Enter region \(region.proximityUUID)");
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Exit region \(region.proximityUUID)");
    }
    
    func beaconIsNear(_ beacons : [CLBeacon]) {
        if let isDelegate = self.delegate {
            for beacon in beacons {
                isDelegate.beaconInErea(beacon)
            }
        }
    }
    
    fileprivate func getClosestBeacon(_ beaconsList : [CLBeacon]?)->CLBeacon? {
        if let isBeaconsList = beaconsList {
            if isBeaconsList.count > 0 {
                var closesBeacon = isBeaconsList.first
                for beacon in isBeaconsList {
                    if let isClosestProximity = closesBeacon?.accuracy {
                        if beacon.accuracy < isClosestProximity {
                            closesBeacon = beacon
                        }
                    }
                }
                print("Cosest beacon major = \(closesBeacon?.major))")
                return closesBeacon
            }
        }
        return nil
    }
    
    fileprivate func getOnlyCloseBeacons(_ beacons : [CLBeacon])->[CLBeacon] {
        var closeBeacons = [CLBeacon]()
        for beacon in beacons {
            if beacon.accuracy < self.minimunDistanceToBeacon {
                closeBeacons.append(beacon)
            }
        }
        return closeBeacons
    }
    
    
    fileprivate func printBeaconInfo(_ beacon : CLBeacon) {
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



//
//  IbeaconService.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

//import Foundation
//import UIKit
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//
//protocol IbeaconsTrackerDelegate {
//    func beaconInErea(_ clBeacon : CLBeacon)
//}
//
//class IbeaconsTracker : NSObject  , KTKLocationManagerDelegate {
//    var delegate : IbeaconsTrackerDelegate?
//    let minimunDistanceToBeacon = 1.3 //In miters
//    let searchForBeaconDelayTime = 2.0
//    let locationManager = KTKLocationManager()
//    var currentClosesBeacon : CLBeacon?
//    var beaconsInErea : [CLBeacon]?
//    
//    override init() {
//        super.init()
//        
//        
//        self.locationManager.delegate = self
//        
//        if (KTKLocationManager.canMonitorBeacons() == false) {
//            print("Can not monitor beacons")
//        }
//        
//        let region = KTKRegion(uuid: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
//        self.locationManager.setRegions([region])
//        self.locationManager.startMonitoringBeacons()
//        
//        if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.available {
//            print("Background updates are available for the app.")
//        }else if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.denied
//        {
//            print("The user explicitly disabled background behavior for this app or for the whole system.")
//        }else if UIApplication.shared.backgroundRefreshStatus == UIBackgroundRefreshStatus.restricted
//        {
//            print("Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.")
//        }
//        
//    }
//    
//    internal func StopMonitoring() {
//        self.locationManager.stopMonitoringBeacons()
//    }
//    
//    
//    internal func isThereABeaconInArea(_ handler: (( _ result : Bool, _ beacon : CLBeacon?) -> Void)!) {
//        self.currentClosesBeacon = nil
//        let delayTime = DispatchTime.now() + Double(Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: delayTime) {
//            if let _ = self.currentClosesBeacon {
//                handler(true, self.currentClosesBeacon)
//            } else {
//            handler(false, nil)
//            }
//        }
//    }
//    
//    internal func isBeaconInErea(_ iBeaconIdentifier : IBeaconIdentifier , handler: (( _ result : Bool) -> Void)!) {
//        self.beaconsInErea = []
//        let delayTime = DispatchTime.now() + Double(Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: delayTime) {
//            
//            var isExists = false
//            if let isBeaconsInErea = self.beaconsInErea {
//                for beacon in isBeaconsInErea {
//                    let currenctBeaconIdentifer = IBeaconIdentifier.creatFromCLBeacon(beacon)
//                    if currenctBeaconIdentifer.majorAppendedByMinorString() == iBeaconIdentifier.majorAppendedByMinorString() {
//                        isExists = true
//                    }
//                }
//             handler((isExists))
//            } else {
//                handler((false))
//            }
//        }
//    
//    }
//    
//    //MARK: Private
//    //MARK: LocationManagerDelegate
//    
//    
//    func locationManager(_ locationManager: KTKLocationManager!, didChange state: KTKLocationManagerState, withError error: Error!) {
//        print(IbeaconsTrackerHelper.locationManagerStateToString(state))
//    }
//    
//    func locationManager(_ locationManager: KTKLocationManager!, didRangeBeacons beacons: [Any]!) {
//        self.beaconsInErea?.removeAll()
//        
//        let onlyCloseBeacons = self.getOnlyCloseBeacons(beacons as! [CLBeacon])
//        self.beaconsInErea = onlyCloseBeacons
//        self.beaconIsNear(onlyCloseBeacons)
//        
//        print("Ranged Close count: \(onlyCloseBeacons.count)")
//        print("Ranged beacons count: \(beacons.count)")
//        if ((beacons.count > 0) == false) {
//            return
//        }
//        let beacon = self.getClosestBeacon(beacons as? [CLBeacon])
//        if beacon?.accuracy < self.minimunDistanceToBeacon {
//            self.currentClosesBeacon = beacon
//        }
//
//    }
//    
//    func locationManager(_ locationManager: KTKLocationManager!, didEnter region: KTKRegion!) {
//        print("Enter region \(region.uuid)");
//    }
//    
//    func locationManager(_ locationManager: KTKLocationManager!, didExitRegion region: KTKRegion!) {
//        print("Exit region \(region.uuid)");
//    }
//    
//    func beaconIsNear(_ beacons : [CLBeacon]) {
//        if let isDelegate = self.delegate {
//            for beacon in beacons {
//                isDelegate.beaconInErea(beacon)
//            }
//        }
//    }
//    
//    fileprivate func getClosestBeacon(_ beaconsList : [CLBeacon]?)->CLBeacon? {
//        if let isBeaconsList = beaconsList {
//            if isBeaconsList.count > 0 {
//                var closesBeacon = isBeaconsList.first
//                for beacon in isBeaconsList {
//                    if let isClosestProximity = closesBeacon?.accuracy {
//                        if beacon.accuracy < isClosestProximity {
//                            closesBeacon = beacon
//                        }
//                    }
//                }
//                print("Cosest beacon major = \(closesBeacon?.major))")
//                return closesBeacon
//            }
//        }
//        return nil
//    }
//    
//    fileprivate func getOnlyCloseBeacons(_ beacons : [CLBeacon])->[CLBeacon] {
//        var closeBeacons = [CLBeacon]()
//        for beacon in beacons {
//            if beacon.accuracy < self.minimunDistanceToBeacon {
//                closeBeacons.append(beacon)
//            }
//        }
//        return closeBeacons
//    }
//    
//    
//    fileprivate func printBeaconInfo(_ beacon : CLBeacon) {
//        print("IBeacon rssi = \(beacon.rssi) uuid  = \(beacon.proximityUUID) accurecy = \(beacon.accuracy)")
//        switch (beacon.proximity) {
//        case CLProximity.far:
//            print("Distance Far for major = \(beacon.major) minor = \(beacon.minor)")
//            break;
//        case CLProximity.immediate:
//            print("Distance Immediate for major = \(beacon.major) minor = \(beacon.minor)")
//            break;
//        case CLProximity.unknown:
//            print("Distance Unknown for major = \(beacon.major) minor = \(beacon.minor)")
//            break;
//        case CLProximity.near:
//            print("Distance Near for major = \(beacon.major) minor = \(beacon.minor)")
//            break;
//        }
//        print("")
//        print("")
//        print("")
//
//    }
//
//}



