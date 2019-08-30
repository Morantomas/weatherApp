//
//  Networking.swift
//  WeatherTest
//
//  Created by Tomas Moran on 27/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

let API_URL = "http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=449e42acf222bac7e1cfdcca3de3558d"

//Constants
let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
let APP_ID = "2f0297ae6a44f55cc6fb3af51170ad79"

let WEATHER_URL_EXTENDED = "http://api.openweathermap.org/data/2.5/forecast"

//Write the protocol declaration here:
protocol GetResponseProtocol {
    func SuccesResponse(_ responseLocation:CityModel)
    func SuccesResponsePronosticoExtended(_ response:[PronosticoModel])
    func ErrorResponse(_ responseData:AnyObject!)
}

class NetworkingHandler {
    
    static let sharedInstance = NetworkingHandler()
    var responseDelegate: GetResponseProtocol?
    
    var pronosticoDataSource: [PronosticoModel] = []
    
    func getWeatherLocation(url: String, params: [String:String]) {
//        SVProgressHUD.show(withStatus: "Loading... ")
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            
            let weatherJSON: JSON = JSON(response.result.value!)
            if response.result.isSuccess {
                print("SUCCES RESPONSE")
                
                //Kelvin to CELCIUS
                let temp = weatherJSON["main"]["temp"].double
                let temperature = (temp! - 273.15).rounded(toPlaces: 0)
                print(temperature)
                
                let cityName = weatherJSON["name"].stringValue
                print(cityName)
                
                let tempdate = weatherJSON["dt"].double
                let convertedDate = Date(timeIntervalSince1970: tempdate!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                let currentDate = dateFormatter.string(from: convertedDate)
                print(convertedDate.dayOfTheWeek())
                print(currentDate)
                
                let weatherType = weatherJSON["weather"][0]["main"].stringValue
                print(weatherType)
                
                let condition = weatherJSON["weather"][0]["id"].intValue
                print(condition)
                
                let country = weatherJSON["sys"]["country"].stringValue
                print(country)
                
                let ciudad: CityModel = CityModel(withName: cityName, country: country, temp: temperature, date: currentDate, type: weatherType, cond: condition)
                
                self.responseDelegate?.SuccesResponse(ciudad)
                
            } else {
                print("ERROR RESPONSE")
                self.responseDelegate?.ErrorResponse(weatherJSON as AnyObject)
            }
        }
    }
    
    func getPronosticoExtended(url: String, params: [String:String]) {
//        SVProgressHUD.show(withStatus: "Loading... ")
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("SUCCES RESPONSE")
                let result = response.result
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let list = dict["list"] as? [Dictionary <String, AnyObject>] {
                        for item in list {
                            let pronostico = PronosticoModel(weatherDict: item)
                            self.pronosticoDataSource.append(pronostico)
                        }
                    }
                }
                
                self.responseDelegate?.SuccesResponsePronosticoExtended(self.pronosticoDataSource)
                
            } else {
                print("ERROR RESPONSE")
                self.responseDelegate?.ErrorResponse(response as AnyObject)
            }
        }
        
    }
    
}
