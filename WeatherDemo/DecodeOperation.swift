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
    
    var error: Error?
    
    var decodedResult: T?
    
    init(data: Data) {
        self.data = data
    }
    
    override func main() {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(T.self, from: data)
            self.decodedResult = response
        }
        catch {
            print("Decoding error:", error.localizedDescription)
            self.error = error
        }
    }
    
}
