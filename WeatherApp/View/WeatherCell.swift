//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by SimpuMind on 5/19/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weedSpeedLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
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
    
    
    func configCell(list: List){
        
        let date = Date(timeIntervalSince1970: list.dt)
        self.dayLabel.text = self.dayFormatter.string(from: date)
        self.dateLabel.text = self.dateFormatter.string(from: date)
        let temperatureMin = list.main.tempMin
        let temperatureMax = list.main.tempMax
        
        let windSpeed = list.wind.speed
        let min = String(format: "%.0f°", temperatureMin)
        let max = String(format: "%.0f°", temperatureMax)
        
        degreeLabel.text = "\(min) - \(max)"
        weedSpeedLabel.text = String(format: "%.f MPH", windSpeed)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
