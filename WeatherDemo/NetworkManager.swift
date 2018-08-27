//
//  NetworkManager.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import CoreLocation
import UIKit

class NetworkManager {
    
    func fetchWeatherData(for location: CLLocation, completion: @escaping ((WeatherInfo?, String?) -> Void)) {
        
        // Create URL using location provided
        guard let url = URLConfigurator().createWeatherURL(location: location, units: .metric) else {
            completion(nil, "Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        // Create task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Create variable that will be passed in the completion closure
            var errorDescription: String?
            
            // Create variable for data, this data will be decoded later
            var weatherData: Data?
            
            // Check if error occured
            if let error = error as NSError?
            {
                // If task timed out or there is no internet connection
                if error.code == NSURLErrorTimedOut || error.code == NSURLErrorNotConnectedToInternet {
                    
                    // Retrieve cached weather data if exists
                    if let cachedData = CacheManager().cachedDataInDirectory(CacheManager.weatherCacheDirectory) {
                        weatherData = cachedData
                    }
                }
                
                // Assign error description to errorDescription variable to show to the user
                errorDescription = error.localizedDescription
            }
            else {
                
                // Check if response is valid
                if let httpResponse = response as? HTTPURLResponse {
                    
                    // Check if status code is positive
                    if httpResponse.statusCode / 100 == 2 {
                        
                        // Check if data is valid
                        if let data = data {
                            
                            // Assign data to the pre-created property that will be used to decode this data
                            weatherData = data
                            
                            // Save data to cache
                            CacheManager().saveToCache(data, directory: CacheManager.weatherCacheDirectory)
                            
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
            if let weatherData = weatherData { // Decode data if it was acquired
                
                // Create decoding operation
                let decodeOperation = DecodeOperation<WeatherResponseModel>(data: weatherData, completion: { (decodedResult, error) in
                    
                    if let weatherData = decodedResult { // Check data was decoded successfully
                        
                        let weatherInfo = WeatherInfo(weatherData: weatherData) // Create weather info object that will be used to display data on the screen
                        
                        // Notify that weather data was acquired successfully
                        completion(weatherInfo, errorDescription)
                    }
                    else { // If failed to decode data
                        
                        // Notify that weather data was not decoded with the reason
                        completion(nil, error?.localizedDescription)
                    }
                    
                })
                // Set very high priority, as data should be processed as soon as possible
                //decodeOperation.queuePriority = .veryHigh
                
                // Add operation to queue
                OperationQueue().addOperation(decodeOperation)
            }
            else { // If no data
                let errorInfo: String
                
                if let errorDescription = errorDescription { // Check reason has been provided
                    errorInfo = errorDescription
                }
                else { // Generic reason for failure
                    errorInfo = "Failed to aquire weather data"
                }
                // Notify that weather data was not acquired with reason
                completion(nil, errorInfo)
            }
        }
        
        // Run task
        task.resume()
    }
    
    func downloadImage(imageURL: URL, completion: @escaping ((UIImage?, String?) -> Void)) {

        let request = URLRequest(url: imageURL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var errorDescription: String? = nil
            var image: UIImage?
            
            if let error = error as NSError? {
                if error.code == NSURLErrorTimedOut || error.code == NSURLErrorNotConnectedToInternet {
                    
                    if let cachedImage = CacheManager().cachedImage(for: CacheManager.weatherImageCacheKey) {
                        image = cachedImage
                    }
                    
                }
                errorDescription = error.localizedDescription
            }
            else {
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode / 100 == 2 {
                        if let data = data {
                            if let weatherImage = UIImage(data: data) {
                                image = weatherImage
                                CacheManager().cacheImage(weatherImage, identifier: CacheManager.weatherImageCacheKey)
                            }
                            else {
                                errorDescription = "Wrong image data."
                            }
                        }
                        else {
                            errorDescription = "Image data unavailable."
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
            completion(image, errorDescription)
        }
        task.resume()
    }
    
}
