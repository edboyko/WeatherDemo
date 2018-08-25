//
//  NetworkManager.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import CoreLocation

class NetworkManager {
    
    func fetchWeatherData(for location: CLLocation, completion: @escaping ((WeatherResponseModel?, String?) -> Void)) {
        
        guard let url = URLConfigurator().createWeatherURL(location: location, units: .metric) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var errorDescription: String? = nil
            
            if let error = error {
                errorDescription = error.localizedDescription
            }
            else {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode / 100 == 2 {
                        
                        if let data = data {
                            
                            print("data acquired")
                            
                            let decodeOperation = DecodeOperation<WeatherResponseModel>(data: data)
                            decodeOperation.completionBlock = { [weak decodeOperation] () in
                                completion(decodeOperation?.decodedResult, decodeOperation?.error?.localizedDescription)
                            }
                            
                            OperationQueue().addOperation(decodeOperation)
                            
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
            if let errorDescription = errorDescription {
                completion(nil, errorDescription)
            }
        }
        task.resume()
        
    }
    
    private func decodeData(data: Data) {
        
    }
}
