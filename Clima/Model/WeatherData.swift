
/**
 
 * Example API response structure:
 * {
 *   "name": "London",
 *   "main": {
 *     "temp": 15.5
 *   },
 *   "weather": [
 *     {
 *       "description": "clear sky",
 *       "id": 800
 *     }
 *   ]
 * }
 */


struct WeatherData: Codable{
    
    /// City name as returned by the API
    let name: String
    
    /// Main weather data container (contains temperature and other metrics)
    let main: Main
    
    /// Array of weather condition objects (usually contains one element)
    /// Note: OpenWeatherMap returns an array but typically only has one weather condition
    let weather: [Weather]
}


struct Main: Codable{
    let temp: Double
}


struct Weather: Codable {
    let description: String
    let id: Int
}
