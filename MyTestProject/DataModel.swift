//
//  DataModel.swift
//  MyTestProject
//
//  Created by Kakha on 17.08.25.
//

import Foundation
import SwiftUI

struct WeatherResponse:Codable {
    let name: String
    let main: Main
    let weather:  [Weather]
}

struct Main:Codable {
    let temp: Double
}

struct Weather:Codable {
    let main: String
    let description: String
}





enum WeatherType: String {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
    case thunderstorm = "Thunderstorm"
    case unknown = "Unknown"
    
    var symbol: String {
        switch self {
        case .clear: return "sun.max.fill"
        case .clouds: return "cloud.fill"
        case .rain: return "cloud.rain.fill"
        case .snow: return "snow"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .unknown: return "questionmark"
        }
    }
    
    var background: Color {
        switch self {
        case .clear: return Color.yellow.opacity(0.5)
        case .clouds: return Color.gray.opacity(0.5)
        case .rain: return Color.blue.opacity(0.5)
        case .snow: return Color.white.opacity(0.5)
        case .thunderstorm: return Color.purple.opacity(0.5)
        case .unknown: return Color.gray
        }
    }
}
