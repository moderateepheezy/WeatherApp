
//
//  DataManager.swift
//  WeatherApp
//
//  Created by SimpuMind on 5/18/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import Foundation
import UIKit

enum DataManagerError: Error {
    
    case unknown
    case failedRequest
    case invalidResponse
    
}

final class DataManager {
    
    typealias WeatherDataCompletion = (WeatherData?, DataManagerError?) -> ()
    typealias WeekWeatherDataCompletion = (WeekWeatherData?, DataManagerError?) -> ()
    
    // MARK: - Properties

    
    // MARK: - Initialization
    
    init() {
        
    }
    
    // MARK: - Requesting Data
    
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        // Create URL
        var urlComponents = URLComponents(string: API.DayBaseURL.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: Constant.API_KEY)
        ]
        
        let baseURL = urlComponents.url!
        
        // Create Data Task
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            
            if let _ = error {
                completion(nil, .failedRequest)
                
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                
                if response.statusCode == 200 {
                    do {
                        // Decode JSON
                        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                        // Invoke Completion Handler
                        
                        DispatchQueue.main.async {
                            completion(weatherData, nil)
                        }
                        
                    } catch {
                        // Invoke Completion Handler
                        completion(nil, .invalidResponse)
                    }
                } else {
                    completion(nil, .failedRequest)
                }
                
            } else {
                completion(nil, .unknown)
            }
        }.resume()
    }
    
    func weekWeatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeekWeatherDataCompletion){
        var urlComponents = URLComponents(string: API.ForecastBaseURL.absoluteString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: Constant.API_KEY)
        ]
        
        let baseURL = urlComponents.url!
        
        // Create Data Task
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            
            if let _ = error {
                completion(nil, .failedRequest)
                
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                
                if response.statusCode == 200 {
                    do {
                        // Decode JSON
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        print(jsonData)
                        let weekData = try JSONDecoder().decode(WeekWeatherData.self, from: data)
                        // Invoke Completion Handler
                        print(weekData)
                        
                        DispatchQueue.main.async {
                            completion(weekData, nil)
                        }
                        
                    } catch {
                        // Invoke Completion Handler
                        completion(nil, .invalidResponse)
                    }
                } else {
                    completion(nil, .failedRequest)
                }
                
            } else {
                completion(nil, .unknown)
            }
        }.resume()
    }
    
    func getImageFromUrl(imageName: String, completion: @escaping (UIImage?, Error?) -> ()) {
        let urlString = "http://openweathermap.org/img/w/\(imageName).png"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data), nil)
            }
        }.resume()
    }
    
}
