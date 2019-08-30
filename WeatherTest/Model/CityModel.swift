
//
//  City.swift
//  WeatherTest
//
//  Created by Tomas Moran on 29/08/2019.
//  Copyright © 2019 Tomas Moran. All rights reserved.
//

import Foundation

class CityModel {
    
    //Declare your model variables here
    var cityName: String?
    var countryCity: String?
    var temperature: Double?
    var currentDate: String?
    var weatherType: String?
    
    var latitude: String?
    var longitude: String?
    var cityID: String?
    
    var condition: Int?
    var weatherIcon: String?
    
    init(withName name: String?, country: String?, temp: Double?, date: String?, type: String?, cond: Int?) {
        cityName = name
        temperature = temp
        currentDate = date
        weatherType = type
        countryCity = country
        
        condition = cond
        weatherIcon = setWeatherIcon(withType: cond ?? -1)
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
