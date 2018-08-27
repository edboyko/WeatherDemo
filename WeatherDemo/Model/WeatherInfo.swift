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
    var imageURL: URL?
    
    var dateUpdated: Date? {
        return CacheManager.lastDateCacheSavingForDirectory(CacheManager.weatherCacheDirectory)
    }
    
    init(weatherData: WeatherResponseModel) {
        locationName = weatherData.name
        windSpeedValue = weatherData.wind.speed
        windDegreesValue = weatherData.wind.deg
        if let weather = weatherData.weather.first {
            conditions = weather.main
            imageURL = URLConfigurator().createWeatherImageURL(imageName: weather.icon)
        }
        
        airTemperatureValue = weatherData.main.temp
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
    
    var lastUpdatedString: String? {
        guard let lastUpdated = dateUpdated else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return String(format: "Last updated: %@", formatter.string(from: lastUpdated))  
    }
    
    
}
