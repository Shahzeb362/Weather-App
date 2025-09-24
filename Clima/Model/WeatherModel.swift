//
//  WeatherModel.swift
//  Clima
//
//  Created by Shahzeb Khan on 26.08.25.
//  

// This struct is our custom "Weather Model"
// It stores weather data and also provides computed values for UI
struct WeatherModel {
    
    // Properties (data we receive from API)
    let conditionID: Int       // Weather condition code (e.g. 800 = clear sky)
    let cityName: String       // City name (e.g. "London")
    let temperature: Double    // Temperature value in Celsius
    
    
    // Computed property = (makes temperature a string with no decimals)
    var TemperatureStr: String {
        let str = String(format: "%.0f", temperature) // Convert to string (e.g. 23.5 → "24")
        return str
    }
    
    // Computed property = converts weather condition ID into SF Symbol name
    // So we can show the right icon (sun, cloud, rain, etc.)
    var ConditionID: String {
        switch conditionID {
        case 200...321:
            return "cloud.bolt"    // Thunderstorm
        case 300...321:
            return "cloud.drizzle" // Drizzle
        case 500...531:
            return "cloud.rain"    // Rain
        case 600...622:
            return "cloud.snow"    // Snow
        case 701...781:
            return "cloud.fog"     // Fog, mist, haze
        case 800:
            return "sun.max"       // Clear sky
        case 801...804:
            return "cloud.sun"     // Partly cloudy
        default:
            return "cloud"         // Default (any other case)
        }
    }
}
