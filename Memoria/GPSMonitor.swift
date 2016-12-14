//
//  GPSMonitor.swift
//  Memoria
//
//  Created by Matan Cohen on 12/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import CoreLocation

class GPSMonitor: NSObject, CLLocationManagerDelegate {
    let dataBase: DataBase
    let locationManager: CLLocationManager = CLLocationManager()

    
    init(dataBase: DataBase) {
        self.dataBase = dataBase
        super.init();
        self.setup()
    }
    
    func setup() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //Delegate
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        let lat = String(format: "%.4f",
                         latestLocation.coordinate.latitude);
        
        
        let lon =  String(format: "%.4f",
                          latestLocation.coordinate.longitude)
        
        
        self.dataBase.saveLocation(lat: lat, lon: lon);
        print("Location updated : Lat =\(lat) lon = \(lon)");
        
    }
}
