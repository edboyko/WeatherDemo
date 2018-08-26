//
//  CacheManager.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation

class CacheManager {
    
    private static let cachesFolder = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    
    private static let defaultDirectory = "weather"
    
    func saveToCashe(_ data: Data, directory: String? = nil) {
        let operaion = BlockOperation {
            do {
                let directoryName: String
                if let directory = directory {
                    directoryName = directory
                }
                else {
                    directoryName = CacheManager.defaultDirectory
                }
                let dataURL = URL(fileURLWithPath: CacheManager.cachesFolder).appendingPathComponent(directoryName)
                
                try data.write(to: dataURL)
            }
            catch {
                print("Error caching data")
            }
        }
        
        operaion.queuePriority = .normal
        
        operaion.completionBlock = { ()
            print("Cached successfully")
            UserDefaults.standard.set(Date(), forKey: "LastSavingCacheDate")
        }
        
        OperationQueue().addOperation(operaion)
    }
    
    var lastSaveCacheDate: Date? {
        return UserDefaults.standard.object(forKey: "LastSavingCacheDate") as? Date
    }
    
    
    func weatherDataFromCache() -> Data? {
        let dataURL = URL(fileURLWithPath: CacheManager.cachesFolder).appendingPathComponent(CacheManager.defaultDirectory)
        do {
            let data = try Data(contentsOf: dataURL)
            return data
        }
        catch {
            print("Failed to get cached data:", error.localizedDescription)
        }
        return nil
    }
    
}
