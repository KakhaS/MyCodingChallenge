//
//  ViewModel.swift
//  MyTestProject
//
//  Created by Kakha on 18.08.25.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var textWidth: CGFloat = 0
    @Published var weatherInfo: String = "Weather info will be displayed here..."
    @Published var currentWeatherType: WeatherType = .unknown
    
    
    func fetchWeatherAsync(for city: String) async -> (String, WeatherType) {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&appid=69aadee7d4e41d76919edfe23d9dd979&units=metric"
        
        guard let url = URL(string: urlString) else {
            return ("URL is not correct", .unknown)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            let info = "\(decoded.name): \(Int(decoded.main.temp))°C, \(decoded.weather.first?.description ?? "")"
            let type = WeatherType(rawValue: decoded.weather.first?.main ?? "") ?? .unknown
            return (info, type)
        } catch {
            return ("Not Correct City Name", .unknown)
        }
    }
    
    //    func fetchWeather(for city: String, completion: @escaping (String, WeatherType) -> Void) {
    //        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
    //        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&appid=69aadee7d4e41d76919edfe23d9dd979&units=metric"
    //
    //        guard let url = URL(string: urlString) else {
    //            completion("URL is not correct", .unknown)
    //            return
    //        }
    //        URLSession.shared.dataTask(with: url) { data, _ , error in
    //            if let error = error {
    //                DispatchQueue.main.async {
    //                    completion("Error: \(error.localizedDescription)", .unknown)
    //                }
    //                return
    //            }
    //            guard let data = data else {
    //                DispatchQueue.main.async {
    //                    completion("NoData", .unknown)
    //                }
    //                return
    //            }
    //            do {
    //                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
    //                let info = "\(decoded.name): \(Int(decoded.main.temp))°C, \(decoded.weather.first?.description ?? "")"
    //                let type = WeatherType(rawValue: decoded.weather.first?.main ?? "Unknown") ?? .unknown
    //                completion(info, type)
    //
    //            }
    //            catch {
    //                DispatchQueue.main.async {
    //                    completion("City name is not correct", .unknown)
    //                }
    //            }
    //
    //        }.resume()
    //    }
}
