//
//  WeatherManager.swift
//  Further Weather
//
//  Created by Kobiraj on 9/2/21.
//

import Foundation

protocol WeatherDataDelegate {
    func didUpdateWeatherData(weather: WeatherModel)
    func didFailWithError(error: Error)
}

class FurtherWeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8acfcee088c2f9f14843dec37c363599&units=metric"
    var weatherDataDelegate: WeatherDataDelegate?
    
    func fetchURL(with cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchURL(with latitute: String, longitude: String) {
        let urlString = "\(weatherURL)&lat=\(latitute)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let sessionTask = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.weatherDataDelegate?.didFailWithError(error: error)
                    return
                }
                
                if let safeData = data{
                    if let parsedData = self.parseJSON(weatherData: safeData) {
                        self.weatherDataDelegate?.didUpdateWeatherData(weather: parsedData)
                        print("\(parsedData.conditionString), \(parsedData.temperatureString)")
                    }
                }
            }
            sessionTask.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedData.name
            let conditionId = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            
            return WeatherModel(cityName: cityName, temp: temperature, conditionId: conditionId)
        } catch {
            self.weatherDataDelegate?.didFailWithError(error: error)
            return nil
        }
    }
}
