//
//  Parser.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation

class Parser {
    
    func weatherInfoFromData(_ data: Data) -> WeatherResponseModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(WeatherResponseModel.self, from: data)
            return response
        }
        catch {
            print("Decoding error:", error.localizedDescription)
        }
        return nil
    }
    
}
