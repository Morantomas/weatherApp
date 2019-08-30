//
//  ViewController.swift
//  WeatherTest
//
//  Created by Tomas Moran on 26/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var imageBackGround: UIImageView!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var imageState: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingCityView: UIView!
    @IBOutlet weak var loadingTableView: UIView!
    
    var pronosticoExtendido: PronosticoModel?
    var pronosticoDataSource: [PronosticoModel] = []
    
    var latitude: String?
    var longitude: String?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SetupSVProgressHUD(withView: loadingCityView)
//        SVProgressHUD.setContainerView(loadingCityView)
//        SVProgressHUD.show(withStatus: "Loading... ")
        
        setDelegates()
        setupBackGroundImage()
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
    
    func setupBackGroundImage() {
        imageBackGround.addBlurEffect()
    }
    
    func setDelegates() {
        NetworkingHandler.sharedInstance.responseDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func SetupSVProgressHUD(withView view: UIView) {
        SVProgressHUD.setRingThickness(3.0)
        SVProgressHUD.setOffsetFromCenter(UIOffset.init(horizontal: 0, vertical: view.tag == 0 ? -200 : 200))
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        SVProgressHUD.show(withStatus: "Loading... ")
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PronosticoCell") as! PronosticoTableViewCell
        cell.configureCell(withData: self.pronosticoDataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pronosticoDataSource.count
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("Longitude = \(location.coordinate.longitude), Latitude = \(location.coordinate.latitude)" )
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            
            if let lat = self.latitude, let long = self.longitude {
                let params: [String:String] = ["lat": lat, "lon": long, "AppID": APP_ID]
                NetworkingHandler.sharedInstance.getWeatherLocation(url: WEATHER_URL, params: params)
            } else {
                SVProgressHUD.dismiss()
                showSimpleAlert()
            }

            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCity" {
            let destinationVC = segue.destination as! SelectCityController
            destinationVC.delegate = self
        }
    }
}

extension ViewController: GetResponseProtocol {

    func SuccesResponse(_ responseCityModel: CityModel) {
        self.ciudadLabel.text = responseCityModel.cityName ?? "City_error"
        self.countryLabel.text = responseCityModel.countryCity ?? "Country_Error"
        self.dateLabel.text = responseCityModel.currentDate ?? "Date_Error"
        self.currentTemp.text = "\(responseCityModel.temperature ?? 0.001)℃"
        self.imageState.image = UIImage(named: responseCityModel.weatherIcon ?? "dunno")
        
        SVProgressHUD.dismiss()
        
//        SVProgressHUD.setContainerView(loadingTableView)
//        SVProgressHUD.show(withStatus: "Loading... ")
//        SVProgressHUD.showProgress(loadingTableView)
        SetupSVProgressHUD(withView: loadingTableView)
        
        let params: [String:String] = ["lat": latitude ?? "", "lon": longitude ?? "", "AppID": APP_ID]
        NetworkingHandler.sharedInstance.getPronosticoExtended(url: WEATHER_URL_EXTENDED, params: params)
    }
    
    func SuccesResponsePronosticoExtended(_ response: [PronosticoModel]) {
        self.pronosticoDataSource = response
        self.tableView.reloadData()
        
        SVProgressHUD.dismiss()
    }
    
    func ErrorResponse(_ responseData: AnyObject!) {
        SVProgressHUD.dismiss()
        showSimpleAlert()
    }
    
}

extension ViewController: SelectCityProtocol {
    
    func changeCity(city: CLLocationCoordinate2D) {
        
        ciudadLabel.text = ""
        countryLabel.text = ""
        dateLabel.text = ""
        currentTemp.text = ""
        imageState.image = UIImage()
        
        pronosticoDataSource.removeAll()
        tableView.reloadData()
        
        self.latitude = city.latitude.description
        self.longitude = city.longitude.description
        
        if let lat = self.latitude, let long = self.longitude {
            SetupSVProgressHUD(withView: loadingCityView)
            let params: [String:String] = ["lat": lat, "lon": long, "AppID": APP_ID]
            NetworkingHandler.sharedInstance.getWeatherLocation(url: WEATHER_URL, params: params)
        } else {
            showSimpleAlert()
        }
    }
    
}

