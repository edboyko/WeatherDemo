//
//  DecodeOperation.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

class DecodeOperation<T>: Operation where T: Decodable {

    private var data: Data
    
    private var completion: ((T?, Error?) -> Void)
    
    /// - Parameters:
    ///   - data: Data that will be decoded
    ///   - completion: Closure that will be executed when finished in the operaion's completion block. This should contain either result or error describing what went wrong
    init(data: Data, completion: @escaping ((T?, Error?) -> Void)) {
        self.data = data
        self.completion = completion
    }
    
    override func main() {
        
        var result: T?
        var decodingError: Error?
        
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(T.self, from: data)
            result = response
        }
        catch {
            print("Decoding error:", error.localizedDescription)
            decodingError = error
        }
        self.completionBlock = nil
        
        self.completionBlock = { [weak self] () in
            self?.completion(result, decodingError)
        }
    }
    
}
