//
//  WeatherManager.swift
//  Clima
//
//  Created by Shahzeb Khan on 22.08.25.
//  

import Foundation

// Protocol = a "contract" that says any class using WeatherManager
// must implement these methods to handle results
protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) // when weather is successfully fetched
    func didFailError(error: Error)  // when an error happens
}


struct WeatherManager {
    
    // Base URL of the weather API (includes API key + units in metric)
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?(Your API)&units=metric"
    
    // Delegate (like a messenger) that will report back to ViewController
    var delegate: WeatherManagerDelegate?
    
    // Function to fetch weather by city name
    func fetchWeather(cityName: String) {
        // Add city name to the URL
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(insertURL: urlString) // call the request function
    }
    
    // Function to fetch weather by latitude & longitude
    func fetchLonLat(longitute: Double, latitute: Double) {
        // Add coordinates to the URL
        let urlString = "\(weatherURL)&lon=\(longitute)&lat=\(latitute)"
        performRequest(insertURL: urlString) // call the performRequest function
    }
    
    
    // Function that actually makes the network call
    func performRequest(insertURL: String) {
        
        // 1. Create a URL object from the string
        if let url = URL(string: insertURL) {
            
            // 2. Create a URLSession (like a browser inside your app)
            let session = URLSession(configuration: .default)
            
            // 3. Create a "task" for the session to fetch data
            let task = session.dataTask(with: url) { data, response, error in
                
                // If an error occurs (like no internet)
                if error != nil {
                    delegate?.didFailError(error: error!) // report error to delegate
                    return
                }
                
                // If we got data back safely
                if let safeData = data {
                    
                    // Try to parse JSON into WeatherModel
                    if let weather = parceJSON(safeData) {
                        // Send parsed weather back to delegate (ViewController)
                        delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
            }
            
            // 4. Start the task (important!)
            task.resume()
        }
    }
    
    
    // Function to decode JSON into our WeatherModel
    func parceJSON(_ weatherData: Data) -> WeatherModel? {
        
        // Create a JSON decoder
        let decoder = JSONDecoder()
        
        do {
            // Try to decode the raw JSON into our WeatherData struct
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            // Extract useful info from JSON
            let city = decodedData.name              // city name
            let temp = decodedData.main.temp         // temperature
            let id = decodedData.weather[0].id       // weather condition ID
            
            // Create our custom WeatherModel object with extracted data
            let weather = WeatherModel(conditionID: id, cityName: city, temperature: temp)
            
            return weather   // send it back
        }
        catch {
            // If decoding fails, report error to delegate
            delegate?.didFailError(error: error)
            return nil
        }
    }
}
