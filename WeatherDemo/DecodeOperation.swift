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
    
    init(data: Data, completion: @escaping ((T?, Error?) -> Void)) {
        self.data = data
        self.completion = completion
    }
    
    override func main() {
        
        var result: T?
        var decodingError: Error?
        
        self.completionBlock = { [weak self] () in
            self?.completion(result, decodingError)
        }
        
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(T.self, from: data)
            result = response
        }
        catch {
            print("Decoding error:", error.localizedDescription)
            decodingError = error
        }
    }
    
}
