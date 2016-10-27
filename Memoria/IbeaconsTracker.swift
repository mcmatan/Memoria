import Foundation
import UIKit


protocol IbeaconsTrackerDelegate {
    func beaconInErea(_ clBeacon : CLBeacon)
}

class IbeaconsTracker : NSObject  , ESTBeaconManagerDelegate {
    var delegate : IbeaconsTrackerDelegate?
    let searchForBeaconDelayTime = 2.0
    let setNearBeaconInterval = 4.0
    let beaconManager = ESTBeaconManager()
    var beaconsNearMeByDate = Dictionary<Date, CLBeacon>()
    var closestBeacon: CLBeacon?
    
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
        let delayTime = DispatchTime.now() + Double(Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if let isLastClosestBeaon = self.closestBeacon {
                handler(true, isLastClosestBeaon)
            }else {
                handler(false, nil)
            }
        }
    }
    
    internal func isBeaconInErea(_ iBeaconIdentifier : IBeaconIdentifier , handler: (( _ result : Bool) -> Void)!) {
        let delayTime = DispatchTime.now() + Double(Int64(self.searchForBeaconDelayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if let _ = self.closestBeacon {
                handler(true)
            }else {
                handler(false)
            }
        }
        
    }
    
    internal func registerForBeacon(uuid: String, major: String, minor: String) {
        let region: CLBeaconRegion = CLBeaconRegion(proximityUUID:UUID(uuidString: uuid)! , major: CLBeaconMajorValue(major)!, minor: CLBeaconMinorValue(minor)!, identifier: "8b06778d9ccf96577eab493295772b18")
        self.beaconManager.startMonitoring(for: region)
    }
    
    internal func unRegisterForBeacon(uuid: String, major: String, minor: String) {
        let region: CLBeaconRegion = CLBeaconRegion(proximityUUID:UUID(uuidString: uuid)! , major: CLBeaconMajorValue(major)!, minor: CLBeaconMinorValue(minor)!, identifier: "Some identifer")
        self.beaconManager.stopMonitoring(for: region)
    }
    
    //MARK: Private
    //MARK: LocationManagerDelegate
    
    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
        print(IbeaconsTrackerHelper.locationManagerStateToString(status))
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        print("Ranged beacons count: \(beacons.count)")
        if ((beacons.count > 0) == false) {
            return
        }
        
        IbeaconsTrackerHelper.printBeaconsInfo(beacons: beacons, region: region)
        
        let closestBeacons = self.getBeaconsNearMe(beacons)
        print("Ranged Close beacons beacons count: \(closestBeacons.count)")
        if ((closestBeacons.count > 0) == false) {
            return
        }
        
        self.removeOldBeaconsFromBeaconsByDate()
        self.addNewBeaconsToBeaconsByDate(beacons: closestBeacons)
        self.checkForMostRandomBeaconAndUpdateNear(beacons: Array(self.beaconsNearMeByDate.values))
        
    }
    
    func addNewBeaconsToBeaconsByDate(beacons: [CLBeacon]) {
        for closeBeacon in beacons {
            self.beaconsNearMeByDate[Date()] = closeBeacon
        }
    }
    
    func removeOldBeaconsFromBeaconsByDate() {
        print("------------------------------------------")
        print("------------------------------------------")
        print("------------------------------------------")
        print("Before valus = \(self.beaconsNearMeByDate)")
        let validTimeInSecounds = -3.0
        
        var datesToRemove = [Date]()
        //Remove old dates
        for date in self.beaconsNearMeByDate.keys {
            if date.timeIntervalSinceNow < validTimeInSecounds {
                datesToRemove.append(date)
                print("Removing date = \(date) and current date = \(Date()) time interva lince now = \(date.timeIntervalSinceNow) valid time in secounds = \(validTimeInSecounds)")
            }
        }
        
        for dateToRemove in datesToRemove {
            self.beaconsNearMeByDate.removeValue(forKey: dateToRemove)
        }
        
        print("After valus = \(self.beaconsNearMeByDate)")
        print("------------------------------------------")
        print("------------------------------------------")
        print("------------------------------------------")
    }
    

    
    func checkForMostRandomBeaconAndUpdateNear(beacons: [CLBeacon]) {
        let repeatedTimeForCountAsClose = 2
        let closestBeacons = beacons.filter { (beacon) -> Bool in
            var repeatedBeaconCount = 0
            for beaconNeaerMe in beacons {
                if beaconNeaerMe.isEqualToBeacon(beacon: beacon) == true {
                        repeatedBeaconCount += 1
                }
            }
            return repeatedBeaconCount >= repeatedTimeForCountAsClose
        }
        
        print("-----------------------------")
        if (closestBeacons.count > 0) == true {
            self.beaconIsNear(beacon: closestBeacons.first! )
            self.closestBeacon = closestBeacons.first
        } else {
            self.closestBeacon = nil
        }
        print("-----------------------------")
    }
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("Enter region \(region.proximityUUID)");
        
        UIApplication.showLocalNotification(text: "Enter region")
        UIApplication.beginBackgroundTask()
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Exit region \(region.proximityUUID)");
        
        UIApplication.showLocalNotification(text: "Exit region")
    }
    
    func beaconIsNear(beacon : CLBeacon) {
        if let isDelegate = self.delegate {
            isDelegate.beaconInErea(beacon)
        }
    }
  
    fileprivate func getBeaconsNearMe(_ beacons : [CLBeacon])->[CLBeacon] {
        var closeBeacons = [CLBeacon]()
        for beacon in beacons {
            if (beacon.proximity == CLProximity.immediate || beacon.proximity == CLProximity.near) {
                closeBeacons.append(beacon)
            }
        }
        return closeBeacons
    }
    

}
