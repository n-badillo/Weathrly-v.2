//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by CSUFTitan on 3/30/20.
//  Copyright © 2020 Nancy Badillo. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var imperialTemperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()  // Gets ahold of phone's current GPS location
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
    
        locationManager.delegate = self;                    // Must be used before you call the methods
        locationManager.requestWhenInUseAuthorization()     // This asks the user for access to the phone's location data in a pop-up.
        
        locationManager.requestLocation()                   // This requests for a one-time delivery of users location
        // If you want to constantly monitor location (GPS/NAVIGATION APPS), use locationManager.startUpdatingLocation()
        
        
        weatherManager.delegate = self;
        // Makes it so that our WeatherDelegate's property is not nil, and will trigger the optional chaining frmom self.delegate?didUpdateWeather(weather: weather)
        
        searchTextField.delegate = self;
        // The text field should point back to the view controller, when the user is done interacting with the text field the text field will let the ViewController know when the user is typing or not.
    }
    

    
    @IBAction func locationPressed(_ sender: UIButton){
        locationManager.requestLocation()
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    // SEARCH BUTTON
    @IBAction func searchButtonPressed(_ sender: UIButton){
        searchTextField.endEditing(true); // Dismisses the keyboard
        
        print(searchTextField.text!);
        // Corresponds to the text displayed in the text field; is not the placeholder text!
    }
    
    
    
    // KEYBOARD RETURN BUTTON
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        searchTextField.endEditing(true); // Dismisses the keyboard
        
        print(searchTextField.text!);
        return true;
        // Will allow us to get ahold of what the user typed, while pressing the "Go" button OR the search button.
    }
    
    // What happens when you deselect a textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else { // Alert the user they need to type into the text field before keyboard is dismissed
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // Delegate method to clear the textfield when editing is ended
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use searchTextField.text to get the weather for that city
        if let city = searchTextField.text{
            weatherManager.getWeather(cityName: city)
        }
        searchTextField.text = "";
        // Clears the search bar after text is returned
    }
}
// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        //temperatureLabel.text = weather.temperatureString;  // ERROR: Updating UI from a Completion Handler
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString;
            self.imperialTemperatureLabel.text = weather.convertedTempString;
            //self.weatherDescriptionLabel.text = weather.weatherDescString;
            self.cityLabel.text = weather.cityName;
            
        }
    }
    
    func didFailWithError(error: Error){
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        // print("Got location data")
        if let location = locations.last { // gets the last location stored in the CLLocation array
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
