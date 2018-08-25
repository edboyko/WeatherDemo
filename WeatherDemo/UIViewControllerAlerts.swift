//
//  UIViewControllerAlerts.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String? = nil) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        controller.addAction(okAction)
        
        return controller
    }
    
}
