//
//  ViewController.swift
//  Clima
//
//  Created by Shahzeb Khan 01/09/2025.
//

import UIKit
import CoreLocation

// Main screen controller for the weather app
class WeatherViewController: UIViewController {
   
    // UI elements from storyboard
    @IBOutlet weak var conditionImageView: UIImageView!   // Weather condition icon (sun, cloud, etc.)
    @IBOutlet weak var temperatureLabel: UILabel!         // Shows temperature
    @IBOutlet weak var cityLabel: UILabel!                // Shows city name
    @IBOutlet weak var searchedTextField: UITextField!    // Text box for typing city name
    
    
    // Create weather manager object (to fetch weather data)
    var weatherManager = WeatherManager()
    
    // Create location manager object (to get user’s location)
    let locationManager = CLLocationManager()
    
    
    // Called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad() // // the main content of viewDidLoad will execute first (system setup) then the code below will work
        
        
        // Tell locationManager that this class (self) will handle its delegate methods
        locationManager.delegate = self
        
        // Ask the user for permission to use their location
        locationManager.requestWhenInUseAuthorization()
        
        // Request the user’s current location once
        locationManager.requestLocation()
        
        // Tell weatherManager that this class will handle its delegate methods
        weatherManager.delegate = self
        
        // Tell searchedTextField that this class will handle its delegate methods
        searchedTextField.delegate = self
    }
    
    // Runs when "location button" is pressed (to get weather by current location)
    @IBAction func LocationPressed(_ sender: UIButton) {
        locationManager.requestLocation() // get current location again
    }
}






//MARK: - UITextFieldDelegate (handles search text box behavior)

extension WeatherViewController: UITextFieldDelegate {
    
    
    // Runs when "search button" is pressed
    @IBAction func searchedPressed(_ sender: UIButton) {
        searchedTextField.endEditing(true)  // Close keyboard
        print(searchedTextField.text!)
    }
    
    
    // This is called when the user taps the Return (search/enter) key on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchedTextField.endEditing(true)  // Close keyboard
        print(searchedTextField.text!)
        return true
    }
    
    // Runs before keyboard closes (decides if editing should end)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != ""){
            return true //ending editing if not empty
        } else{
            textField.placeholder = "Enter location"
            return false // don’t let editing end until user types something
        }
    }
    
   
    //This is called after editing actually ends (after keyboard is dismissed).
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cityName = searchedTextField.text{
            // putting city name in https link
            weatherManager.fetchWeather(cityName: cityName)
        }
        
        searchedTextField.text = ""  // Clear text box
    }
    
}






//MARK: - WeatherManagerDelegate (handles weather data updates)

extension WeatherViewController: WeatherManagerDelegate {
    
    // Called when new weather data is received
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        
        // Update UI on the main thread
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = weather.TemperatureStr // Show temperature
            self.conditionImageView.image = UIImage(systemName: weather.ConditionID) // Show icon
            self.cityLabel.text = weather.cityName              // Show city name
        }
    }

    // Called when something goes wrong (like network error)
    func didFailError(error: any Error) {
        print(error)
    }
}






//MARK: - CLLocationManagerDelegate (handles user location updates)

extension WeatherViewController: CLLocationManagerDelegate {
    
    // Called when location is successfully found
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locate = locations.last {                // Take the latest location
            locationManager.stopUpdatingLocation()      // Stop updating (to save battery)
            let lat = locate.coordinate.latitude        // Get latitude
            let lon = locate.coordinate.longitude       // Get longitude
            weatherManager.fetchLonLat(longitute: lon, latitute: lat) // Fetch weather using coordinates
        }
    }
    
    // Called when location fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
