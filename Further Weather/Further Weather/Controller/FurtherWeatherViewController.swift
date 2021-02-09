//
//  FurtherWeatherViewController.swift
//  Further Weather
//
//  Created by Kobiraj on 9/2/21.
//

import UIKit
import CoreLocation

class FurtherWeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var weatherManager = FurtherWeatherManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        weatherManager.weatherDataDelegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
}

// MARK: - TextFieldDelegate Section
extension FurtherWeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            weatherManager.fetchURL(with: cityName)
        }
        searchTextField.text = ""
    }
}

// MARK: - FurtherWeatherDataDelegate Section
extension FurtherWeatherViewController: FurtherWeatherDataDelegate {
    func didUpdateWeatherData(weather: FurtherWeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.weatherConditionImage.image = UIImage(systemName: weather.conditionString)
            self.temperatureLabel.text = weather.temperatureString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension FurtherWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchURL(with: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
