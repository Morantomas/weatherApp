//
//  LocationManager.swift
//  WeatherTest
//
//  Created by Tomas Moran on 27/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    let locationManager = CLLocationManager()
    
    func setupLocation(){
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocation() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocation()
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
    
}
