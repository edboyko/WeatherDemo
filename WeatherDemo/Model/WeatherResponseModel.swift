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
    var dt: Double
    struct Main: Decodable {
        var temp: Double
    }
    var main: Main
    
    var weather: [Weather]
    struct Weather: Decodable {
        var main: String
        var icon: String
    }
    
    var wind: Wind
    
    struct Wind: Decodable {
        var speed: Double
        var deg: Double
    }
    struct Coord: Decodable {
        var lon: Double
        var lat: Double
    }
    
}
