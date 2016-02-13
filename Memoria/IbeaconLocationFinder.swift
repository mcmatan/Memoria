//
//  IbeaconService.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit


class IbeaconLocationFinder : NSObject,  KTKLocationManagerDelegate {
    let minimunDistanceToBeacon = 1.0
    let searchForBeaconDelayTime = 2.0
    let locationManager = KTKLocationManager()
    var currentClosesBeacon : CLBeacon?
    var beaconsInErea : [CLBeacon]?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        
        if (KTKLocationManager.canMonitorBeacons() == false) {
            print("Can not monitor beacons")
        }
        
        let region = KTKRegion(UUID: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
        self.locationManager.setRegions([region])
        self.locationManager.startMonitoringBeacons()
        
        if UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Available {
            print("Background updates are available for the app.")
        }else if UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Denied
        {
            print("The user explicitly disabled background behavior for this app or for the whole system.")
        }else if UIApplication.sharedApplication().backgroundRefreshStatus == UIBackgroundRefreshStatus.Restricted
        {
            print("Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.")
        }
        
    }
    
    internal func StopMonitoring() {
        self.locationManager.stopMonitoringBeacons()
    }
    
    
    internal func isThereABeaconInArea(handler: (( result : Bool, beacon : CLBeacon?) -> Void)!) {
        self.currentClosesBeacon = nil
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if let _ = self.currentClosesBeacon {
                handler(result: true, beacon: self.currentClosesBeacon)
            }
            handler(result: false, beacon: nil)
        }
    }
    
    internal func isBeaconInErea(iBeaconIdentifier : IBeaconIdentifier , handler: (( result : Bool) -> Void)!) {
        self.beaconsInErea = []
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            var isExists = false
            if let isBeaconsInErea = self.beaconsInErea {
                for beacon in isBeaconsInErea {
                    let currenctBeaconIdentifer = IBeaconIdentifier.creatFromCLBeacon(beacon)
                    if currenctBeaconIdentifer.majorAppendedByMinorString() == iBeaconIdentifier.majorAppendedByMinorString() {
                        isExists = true
                    }
                }
             handler(result: (isExists))
            } else {
                handler(result: (false))
            }
        }
    
    }
    
    //MARK: LocationManagerDelegate
    
     func locationManager(locationManager: KTKLocationManager!, didChangeState state: KTKLocationManagerState, withError error: NSError!) {
        print(IbeaconLocationFinderHelper.locationManagerStateToString(state))
    }
    
    func locationManager(locationManager: KTKLocationManager!, didEnterRegion region: KTKRegion!) {
        print("Enter region \(region.uuid)");
    }
    
    func locationManager(locationManager: KTKLocationManager!, didExitRegion region: KTKRegion!) {
        print("Exit region \(region.uuid)");
    }
    
    func locationManager(locationManager: KTKLocationManager!, didRangeBeacons beacons: [AnyObject]!) {
        self.beaconsInErea = beacons as? [CLBeacon]
        
        for currenctBeacon in (beacons as? [CLBeacon])! {
            if currenctBeacon.accuracy < self.minimunDistanceToBeacon {
                if ((self.beaconsInErea?.contains(currenctBeacon)) != nil) {
                    self.beaconsInErea?.removeAtIndex((self.beaconsInErea?.indexOf(currenctBeacon))!)
                }
                self.beaconsInErea?.append(currenctBeacon)
            }
        }
        
        print("Ranged beacons count: \(beacons.count)")
        if ((beacons.count > 0) == false) {
            return
        }
        let beacon = self.getClosestBeacon(beacons as? [CLBeacon])
        if beacon?.accuracy < self.minimunDistanceToBeacon {
            self.currentClosesBeacon = beacon
        }
    }
    
    private func getClosestBeacon(beaconsList : [CLBeacon]?)->CLBeacon? {
        if let isBeaconsList = beaconsList {
            if isBeaconsList.count > 0 {
                var closesBeacon = isBeaconsList.first
                for beacon in isBeaconsList {
                    self.printBeaconInfo(beacon)
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
    
    
    private func printBeaconInfo(beacon : CLBeacon) {
        print("IBeacon rssi = \(beacon.rssi) uuid  = \(beacon.proximityUUID) accurecy = \(beacon.accuracy)")
        switch (beacon.proximity) {
        case CLProximity.Far:
            print("Distance Far for major = \(beacon.major) minor = \(beacon.minor)")
            break;
        case CLProximity.Immediate:
            print("Distance Immediate for major = \(beacon.major) minor = \(beacon.minor)")
            break;
        case CLProximity.Unknown:
            print("Distance Unknown for major = \(beacon.major) minor = \(beacon.minor)")
            break;
        case CLProximity.Near:
            print("Distance Near for major = \(beacon.major) minor = \(beacon.minor)")
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationsNames.beaconIsNearNotification, object: beacon)
            break;
        }
        print("")
        print("")
        print("")

    }

}