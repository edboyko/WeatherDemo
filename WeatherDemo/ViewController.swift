//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 22/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
