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
    
    // This will be executed in the operation's completion block
    private var completion: ((T?, Error?) -> Void)
    
    /// - Parameters:
    ///   - data: Data that will be decoded
    ///   - completion: Closure that will be executed when finished in the operaion's completion block. This should contain either result or error describing what went wrong
    init(data: Data, completion: @escaping ((T?, Error?) -> Void)) {
        
        let stringData = String.init(data: data, encoding: String.Encoding.utf8)
        print("JSON:", stringData ?? "NO JSON")
        
        self.data = data
        self.completion = completion
    }
    
    override func main() {
        
        var result: T?
        var decodingError: Error?
        
        // Reset base completion block if was set externally
        self.completionBlock = nil
        
        // Create completion block that will be executed when operation finished
        self.completionBlock = { [weak self] () in
            self?.completion(result, decodingError)
        }
        
        let decoder = JSONDecoder()
        // Try to decode data
        do {
            let decodedResult = try decoder.decode(T.self, from: data)
            
            result = decodedResult
        }
        catch {
            print("Decoding error:", error.localizedDescription)
            decodingError = error
        }
        

    }
    
}
