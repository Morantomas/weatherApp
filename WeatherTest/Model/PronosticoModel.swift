//
//  PronosticoModel.swift
//  WeatherTest
//
//  Created by Tomas Moran on 30/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import Foundation
import SwiftyJSON

class PronosticoModel {
    
    var time: String?
    var temp: String?
    
    var weatherIcon: String?
    
    init(weatherDict: Dictionary <String, AnyObject>) {
        if let tempTest = weatherDict["main"] as? Dictionary<String, AnyObject> {
            if let daytemp = tempTest["temp"] as? Double {
                let temperature = (daytemp - 273.15).rounded(toPlaces: 0)
                self.temp = "\(temperature)℃"
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let convertedDate = Date(timeIntervalSince1970: date)
            self.time = convertedDate.getHour() + "hs."
        }
        
        let weatherJSON: JSON? = JSON(weatherDict["weather"]!)
        if let cond = weatherJSON?[0]["id"].intValue {
            weatherIcon = setWeatherIcon(withType: cond)
        }
    }
    
    func setWeatherIcon(withType type: Int) -> String {
        switch (type) {
        case 0...300:
            return "tstorm1"
        case 301...500:
            return "light_rain"
        case 501...600:
            return "shower3"
        case 601...700:
            return "snow4"
        case 701...771:
            return "fog"
        case 772...799:
            return "tstorm3"
        case 800:
            return "sunny"
        case 801...804:
            return "cloudy2"
        case 900...903, 905...1000:
            return "tstorm3"
        case 903:
            return "snow5"
        case 904:
            return "sunny"
        default:
            return "dunno"
        }
        
    }
}
