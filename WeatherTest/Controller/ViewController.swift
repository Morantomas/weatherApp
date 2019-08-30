//
//  ViewController.swift
//  WeatherTest
//
//  Created by Tomas Moran on 26/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var imageState: UIImageView!
    
    
    let locationManager = CLLocationManager()
    var locationCoordinate: CLLocationCoordinate2D? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Mark:
    func setupLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setDelegatesForProtocol() {
        NetworkingHandler.sharedInstance.responseDelegate = self
    }
    
    func checkLocation() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocation()
            checkLocationAuth()
        } else {
            showSimpleAlert()
        }
    }
    
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
//            showSimpleAlert()
            break
        case .denied:
            showSimpleAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }

    func showSimpleAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Hubo un error al obtener la Ubicacion", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("Longitude = \(location.coordinate.longitude), Latitude = \(location.coordinate.latitude)" )
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String:String] = ["lat": latitude, "lon": longitude, "AppID": APP_ID]
            
            setDelegatesForProtocol()
            NetworkingHandler.sharedInstance.getWeatherLocation(url: WEATHER_URL, params: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        showSimpleAlert()
//        cityLabel.text = "Location Unavailable"
    }
    
}

extension ViewController: GetResponseProtocol {
    
    func SuccesResponse(_ responseCityModel: CityModel) {
        self.ciudadLabel.text = responseCityModel.cityName ?? "City_error"
        self.countryLabel.text = responseCityModel.countryCity ?? "Country_Error"
        self.dateLabel.text = responseCityModel.currentDate ?? "Date_Error"
        self.currentTemp.text = "\(responseCityModel.temperature ?? 0.001)℃"
    }
    
    func ErrorResponse(_ responseData: AnyObject!) {
        showSimpleAlert()
    }
    
}

