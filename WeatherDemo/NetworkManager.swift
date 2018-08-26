//
//  NetworkManager.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import CoreLocation

class NetworkManager {
    
    func fetchWeatherData(for location: CLLocation, completion: @escaping ((WeatherInfo?, String?) -> Void)) {
        
        guard let url = URLConfigurator().createWeatherURL(location: location, units: .metric) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var errorDescription: String? = nil
            var weatherData: Data?
            
            if let error = error as NSError?
            {
                if error.code == NSURLErrorTimedOut || error.code == NSURLErrorNotConnectedToInternet {
                    
                    if let cachedData = CacheManager().cachedDataInDirectory(CacheManager.weatherCacheDirectory) {
                        weatherData = cachedData
                    }
                    else {
                        errorDescription = error.localizedDescription
                    }
                    
                }
                else {
                    errorDescription = error.localizedDescription
                }
            }
            else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode / 100 == 2 {
                        
                        if let data = data {
                            
                            weatherData = data
                            
                        }
                        else {
                            errorDescription = "Failed to fetch data"
                        }
                    }
                    else {
                        errorDescription = String(format: "Error %@", NSNumber(value: httpResponse.statusCode))
                    }
                }
                else {
                    errorDescription = "Response Error"
                }
            }
            if let weatherData = weatherData {
                // Save data to cache
                CacheManager().saveToCache(weatherData, directory: CacheManager.weatherCacheDirectory)
                
                // Decode data
                let decodeOperation = DecodeOperation<WeatherResponseModel>(data: weatherData, completion: { (decodedResult, error) in
                    
                    if let weatherData = decodedResult {
                        
                        let weatherInfo = WeatherInfo(weatherData: weatherData)
                        completion(weatherInfo, nil)
                    }
                    else {
                        completion(nil, error?.localizedDescription)
                    }
                    
                })
                
                OperationQueue().addOperation(decodeOperation)
            }
            else {
                let errorInfo: String
                if let errorDescription = errorDescription {
                    errorInfo = errorDescription
                }
                else {
                    errorInfo = "Failed to aquire weather data"
                }
                completion(nil, errorInfo)
            }
        }
        task.resume()
    }
    
    private func decodeData(data: Data) {
        
    }
}
