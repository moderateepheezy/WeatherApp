//
//  Constant.swift
//  WeatherApp
//
//  Created by SimpuMind on 5/18/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import Foundation

class Constant {
    
    static let API_KEY = "1483fc2f47335540602ae5018bab8b58"
    static let BASE_URL = "https://api.openweathermap.org/data/2.5/"
    static let FORECAST = "forecast"
    static let WEATHER = "weather"
}


struct Defaults {
    
    static let Latitude: Double = 51.400592
    static let Longitude: Double = 4.760970
    
}

struct API {
    
    static let APIKey = Constant.API_KEY
    static let BaseURL = URL(string: Constant.BASE_URL)!
    
    static var DayBaseURL: URL {
        return BaseURL.appendingPathComponent(Constant.WEATHER)
    }
    
    static var ForecastBaseURL: URL {
        return BaseURL.appendingPathComponent(Constant.FORECAST)
    }
    
}
