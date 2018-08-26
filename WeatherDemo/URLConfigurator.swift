//
//  URLConfigurator.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import CoreLocation

enum Units: String {
    case Standard
    case metric
    case imperial
    
    var temperatureUnit: UnitTemperature {
        switch self {
        case .metric:
            return .celsius
        case .Standard:
            return .kelvin
        case .imperial:
            return .fahrenheit
        }
    }
}
class URLConfigurator: NSObject {

    private let baseAddress = "https://api.openweathermap.org/data/2.5/weather"
    
    private let apiKey = "<#Insert API Key#>"
    
    func createWeatherURL(location: CLLocation, units: Units? = nil) -> URL? {
        guard var urlComponents = URLComponents(string: baseAddress) else {
            return nil
        }
        let latitude = NSNumber(value: location.coordinate.latitude)
        let longtitude = NSNumber(value: location.coordinate.longitude)
        
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: latitude.stringValue),
            URLQueryItem(name: "lon", value: longtitude.stringValue),
            URLQueryItem(name: "APPID", value: apiKey)
        ]
        if let units = units {
            urlComponents.queryItems?.append(URLQueryItem(name: "units", value: units.rawValue))
        }
        return urlComponents.url

    }
    
}
