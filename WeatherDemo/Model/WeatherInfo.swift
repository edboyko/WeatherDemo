//
//  WeatherInfo.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation

struct WeatherInfo {
    
    private var windSpeedValue: Double
    private var windDegreesValue: Double
    var conditions: String = "N/A"
    private var airTemperatureValue: Double
    var locationName: String
    
    var dateUpdated: Date
    
    init(weatherData: WeatherResponseModel) {
        locationName = weatherData.name
        windSpeedValue = weatherData.wind.speed
        windDegreesValue = weatherData.wind.deg
        if let weatherConditions = weatherData.weather.first?.main {
            conditions = weatherConditions
        }
        airTemperatureValue = weatherData.main.temp
        dateUpdated = Date(timeIntervalSince1970: weatherData.dt)
    }
    
    var windSpeed: String {
        
        let formatter = MeasurementFormatter()
        let measurement = Measurement(value: windSpeedValue, unit: UnitSpeed.metersPerSecond)
        formatter.numberFormatter.maximumFractionDigits = 1
        
        return formatter.string(from: measurement)
    }
    
    var airTemperature: String {
        
        let formatter = MeasurementFormatter()
        let measurement = Measurement(value: airTemperatureValue, unit: UnitTemperature.celsius)
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        
        return formatter.string(from: measurement)
    }
    
    var windDirection: String {
        let directions = ["North",
                          "North East",
                          "East",
                          "South East",
                          "South",
                          "South West",
                          "West",
                          "North West"]
        
        let i = (windDegreesValue + 22.5)/45;
        return directions[Int(i) % directions.count];
    }
    
    var lastUpdatedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return String(format: "Last updated: %@", formatter.string(from: dateUpdated))  
    }
    
    
}
