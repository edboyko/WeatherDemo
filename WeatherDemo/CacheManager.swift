//
//  CacheManager.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation

class CacheManager {
    
    static let weatherCacheDirectory = "weather"
    
    private static let cachesFolder = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    
    private static let cacheExpirationDateKey = "LastSavingCacheDate"
    
    private static let defaultDataValidityTime: TimeInterval = TimeInterval(24 * 60 * 60)
    
    private static func cacheExpirationDateKeyForDirectory(_ directory: String) -> String {
        return String(format: "%@_%@", CacheManager.cacheExpirationDateKey, directory)
    }
    
    private static func cacheExpirationDateForDirectory(_ directory: String) -> Date? {
        
        let key = CacheManager.cacheExpirationDateKeyForDirectory(directory)
        return UserDefaults.standard.object(forKey: key) as? Date
    }
    
    private func dataValid(expirationDate: Date) -> Bool {
        if Date().timeIntervalSinceNow > expirationDate.timeIntervalSinceNow {
            return false
        }
        return true
    }
    
    private func expirationDateValid(_ date: Date) -> Bool {
        return date.timeIntervalSinceNow > Date().addingTimeInterval(60 * 29 + 59).timeIntervalSinceNow
    }
    
    // MARK: - Operations with cache
    
    /// - Parameters:
    ///   - data: Data you want to cache
    ///   - directory: A folder with this name will be created in the default caches directory
    ///   - expirationDate: Date when cache will become invalid. Default value is 24 hours from the moment of cache saving. Must be at least 30 minutes in future
    ///   - successBlock: Closure that will be executed when finished. Default value is nil. Bool parameter determines whether saving was successful, String parameter stores path for the file
    func saveToCache(_ data: Data,
                     directory: String,
                     expirationDate: Date = Date().addingTimeInterval(CacheManager.defaultDataValidityTime),
                     successBlock: ((Bool, String) -> Void)? = nil) {
        
        assert(expirationDateValid(expirationDate), "Expiration date must be at least 30 minutes in future")
        var errorMessage: String? = nil
        let dataURL = URL(fileURLWithPath: CacheManager.cachesFolder).appendingPathComponent(directory)
        let operaion = BlockOperation {
            do {
                
                try data.write(to: dataURL)
            }
            catch {
                errorMessage = "Error caching data"
            }
        }
        
        operaion.queuePriority = .normal
        
        operaion.completionBlock = { ()
            let success: Bool
            if let errorMessage = errorMessage {
                success = false
                print(errorMessage)
            }
            else {
                success = true
                print("Cached successfully")
                UserDefaults.standard.set(expirationDate, forKey: CacheManager.cacheExpirationDateKey)
            }
            successBlock?(success, dataURL.path)
        }
        
        OperationQueue().addOperation(operaion)
    }
    
    
    func cachedDataInDirectory(_ directory: String) -> Data? {
        
        if let expirationDate = CacheManager.cacheExpirationDateForDirectory(directory) {
            if dataValid(expirationDate: expirationDate) {
                
                let dataURL = URL(fileURLWithPath: CacheManager.cachesFolder).appendingPathComponent(directory)
                do {
                    let data = try Data(contentsOf: dataURL)
                    return data
                }
                catch {
                    print("Failed to get cached data:", error.localizedDescription)
                }
                
            }
            else {
                deleteCache(from: directory)
            }
        }

        return nil
    }
    
    func deleteCache(from directory: String, successBlock: ((Bool) -> Void)? = nil) {
        
        var errorMessage: String? = nil
        
        let operaion = BlockOperation {
            
            let dataURL = URL(fileURLWithPath: CacheManager.cachesFolder).appendingPathComponent(directory)
            if FileManager.default.fileExists(atPath: dataURL.path) {
                
                do {
                    try FileManager.default.removeItem(at: dataURL)
                }
                catch {
                    errorMessage = "Error caching data"
                }
            }
            else {
                print("Cache does not exist in directory:", directory)
            }
        }
        
        operaion.queuePriority = .normal
        
        operaion.completionBlock = { ()
            let success: Bool
            if let errorMessage = errorMessage {
                print(errorMessage)
                success = false
            }
            else {
                success = true
                print("Cache removed successfully")
                UserDefaults.standard.removeObject(forKey: CacheManager.cacheExpirationDateKey)
            }
            successBlock?(success)
        }
        
        OperationQueue().addOperation(operaion)
    }
    
}
