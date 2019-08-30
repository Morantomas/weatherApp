//
//  SelectCityController.swift
//  WeatherTest
//
//  Created by Tomas Moran on 30/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol SelectCityProtocol {
    func changeCity(city: CLLocationCoordinate2D)
}

enum CityLatLong: Int {
    case CUPERTINO = 0
    case LONDON = 1
    case AMSTERDAM = 2
    case BARCELONA = 3
    case UBICACION = 4
}

class SelectCityController: UIViewController {
    
    var delegate: SelectCityProtocol?
    var locationCoordinate: CLLocationCoordinate2D? {
        didSet {
            delegate?.changeCity(city: self.locationCoordinate!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        if let tag = sender.tag {
            let tagCity: CityLatLong = CityLatLong(rawValue: tag)!
            switch tagCity {
            case .CUPERTINO:
                locationCoordinate = CLLocationCoordinate2D(latitude: 37.323002, longitude: -122.032181)
            case .LONDON:
                locationCoordinate = CLLocationCoordinate2D(latitude: 42.983391, longitude: -81.23304)
            case .AMSTERDAM:
                locationCoordinate = CLLocationCoordinate2D(latitude: 52.374031, longitude: -4.88969)
            case .BARCELONA:
                locationCoordinate = CLLocationCoordinate2D(latitude: 41.38879, longitude: 2.15899)
            case .UBICACION:
                locationCoordinate = CLLocationCoordinate2D(latitude: -34.593806, longitude: -58.412015)
            }
        }
    }
    
    func getCity(withTag: Int) -> String {
        return ""
    }
    
    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
