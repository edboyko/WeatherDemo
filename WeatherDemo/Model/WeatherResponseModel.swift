//
//  WeatherResponseModel.swift
//  WeatherDemo
//
//  Created by Edwin Boyko on 25/08/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation

struct WeatherResponseModel: Decodable {
    var name: String
    struct Main: Decodable {
        var temp: Double
    }
    var main: Main
    
    var weather: [Weather]
    struct Weather: Decodable {
        var main: String
    }
    
    var wind: Wind
    
    struct Wind: Decodable {
        var speed: Float
        var deg: Int
    }
    struct Coord: Decodable {
        var lon: Double
        var lat: Double
    }
    
}
