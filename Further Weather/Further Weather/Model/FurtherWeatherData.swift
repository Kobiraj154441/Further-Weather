//
//  WeatherDataModel.swift
//  Further Weather
//
//  Created by Kobiraj on 9/2/21.
//

import Foundation

struct FurtherWeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Id]
}

struct Main: Codable {
    var temp: Double
}

struct Id: Codable {
    var id: Int
}

struct FurtherWeatherModel {
    var cityName: String
    var temp: Double
    var conditionId: Int
    var temperatureString: String {
        let tempString = String(format: "%0.1f", temp)
        return tempString
    }
    var conditionString: String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
