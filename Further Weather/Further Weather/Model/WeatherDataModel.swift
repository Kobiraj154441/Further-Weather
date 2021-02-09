//
//  WeatherDataModel.swift
//  Further Weather
//
//  Created by Kobiraj on 9/2/21.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var temperature: Main
    var weatherId: [Id]
}

struct Main: Codable {
    var temp: Double
}

struct Id: Codable {
    var id: Int
}
