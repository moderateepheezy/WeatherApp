//
//  WeatherData.swift
//  WeatherApp
//
//  Created by SimpuMind on 5/18/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let base: String
    let wind: Wind
    let clouds: Clouds
    let coord: Coord
    let dt, id, cod: Int
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let name: String
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let humidity: Int
    let tempMin, tempMax, temp, pressure: Double
    
    enum CodingKeys: String, CodingKey {
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp, pressure
    }
}

struct Sys: Codable {
    let message: Double
    let country: String
    let id, sunset, sunrise, type: Int
}

struct Weather: Codable {
    let id: Int
    let main, icon, description: String
}

struct Wind: Codable {
    let speed: Double
    //let deg: Int
}

