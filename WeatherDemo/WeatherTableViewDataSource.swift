//
//  WeatherTableViewDataSource.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 26/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

class WeatherTableViewDataSource: NSObject, UITableViewDataSource {
    
    var weatherData: [String]?
    
    let fields = [
        "Location",
        "Condition",
        "Temperature",
        "Wind Speed",
        "Wind Direction"
    ]
    
    var headerContent: String?
    var footerContent: String?
    
    init(weatherInfo: WeatherInfo) {
        weatherData = [String]()
        
        weatherData?.append(weatherInfo.locationName)
        weatherData?.append(weatherInfo.conditions)
        weatherData?.append(weatherInfo.airTemperature)
        weatherData?.append(weatherInfo.windSpeed)
        weatherData?.append(weatherInfo.windDirection)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weatherData = weatherData {
            return weatherData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell"),
            let weatherData = weatherData else {
                return UITableViewCell()
        }
        
        cell.textLabel?.text = fields[indexPath.row]
        cell.detailTextLabel?.text = weatherData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerContent
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerContent
    }

}
