//
//  Extensions.swift
//  WeatherApp
//
//  Created by SimpuMind on 5/19/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import UIKit

extension Double {
    
    func toCelcius() -> Double {
        return ((self - 32.0) / 1.8)
    }
    
    func toKPH() -> Double {
        return (self * 1.609344)
    }
    
}

extension UIViewController {
    func setAlert(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        present(alertVC, animated: true, completion: nil)
    }
}
