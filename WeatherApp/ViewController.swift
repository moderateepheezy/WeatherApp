//
//  ViewController.swift
//  WeatherApp
//
//  Created by SimpuMind on 5/18/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var dayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter
    }()
    
    private var lists = [List]()
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchWeatherData()
        }
    }
    
    private lazy var dataManager = {
        return DataManager()
    }()
    
    private lazy var locationManager: CLLocationManager = {
        // Initialize Location Manager
        let locationManager = CLLocationManager()
        
        // Configure Location Manager
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = 1000.0
        
        return locationManager
    }()
    
    private func fetchWeatherData() {
        guard let location = currentLocation else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("\(latitude), \(longitude)")
        dataManager.weekWeatherDataForLocation(latitude: latitude, longitude: longitude) { (response, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print(error)
            } else if let weekWeatherData = response {
                self.lists = weekWeatherData.list
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
        dataManager.weatherDataForLocation(latitude: latitude, longitude: longitude) { (response, error) in
            if let error = error {
                print(error)
            } else if let weatherData = response {
                
                self.updateViews(weatherData: weatherData)
            }
        }
    }
    
    private func updateViews(weatherData: WeatherData){
        var windSpeed = weatherData.wind.speed
        var temprature = weatherData.main.temp
        let imageName = weatherData.weather[0].icon
        let date = Date()
        self.timeLabel.text = self.dayFormatter.string(from: date)
        self.dateLabel.text = self.dateFormatter.string(from: date)
        self.descriptionLabel.text = weatherData.weather[0].description
        windSpeed = windSpeed.toKPH()
        self.windSpeedLabel.text = String(format: "%.f KPH", windSpeed)
        temprature = temprature.toCelcius()
        degreeLabel.text = String(format: "%.1f °C", temprature)
        
        dataManager.getImageFromUrl(imageName: imageName) { (image, error) in
            guard let image = image else {return}
            self.currentWeatherImageView.image = image
        }
        
    }
    
    private func requestLocation() {
        // Configure Location Manager
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Request Current Location
            locationManager.requestLocation()
            
        } else {
            // Request Authorization
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationHandling()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        requestLocation()
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    // MARK: - Authorization
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Request Location
            manager.requestLocation()
            
        } else {
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
            self.setAlert(title: "Notice", message: "You did not allow permission, default location will be used, go to settings to allow location dectection")
        }
    }
    
    // MARK: - Location Updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Update Current Location
            currentLocation = location
            
            // Reset Delegate
            manager.delegate = nil
            
            // Stop Location Manager
            manager.stopUpdatingLocation()
            
        } else {
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
            self.setAlert(title: "Notice", message: "You did not allow permission, default location will be used, go to settings to allow location dectection")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        if currentLocation == nil {
            
           currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
            self.setAlert(title: "Notice", message: "You did not allow permission, default location will be used, go to settings to allow location dectection")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherCell
        let list = lists[indexPath.item]
        cell.configCell(list: list)
        let imageName = list.weather[0].icon
        dataManager.getImageFromUrl(imageName: imageName) { (image, error) in
            guard let image = image else {return}
            cell.weatherImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}



