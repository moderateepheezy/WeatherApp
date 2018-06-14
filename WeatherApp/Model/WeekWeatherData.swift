//
//  WeekWeatherData.swift
//  WeatherApp
//
//  Created by SimpuMind on 5/19/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import Foundation

struct WeekWeatherData: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
    let city: City
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
}

struct List: Codable {
    let dt: Double
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case  weather, wind, clouds, dt, main
        
    }
}

struct MainClass: Codable {
    let temp, tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}


enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
}

enum Icon: String, Codable {
    case the01D = "01d"
    case the01N = "01n"
    case the02D = "02d"
    case the02N = "02n"
    case the03N = "03n"
    case the04N = "04n"
}
