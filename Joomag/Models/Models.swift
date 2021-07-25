//
//  Models.swift
//  Joomag
//
//  Created by Artashes Noknok on 6/8/21.
//

import Foundation

// MARK: - Err
struct Err: Codable {
    let success: String?
    let error: Error?
}

// MARK: - Error
struct Error: Codable {
    let code: Int?
    let type, info: String?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let request: Request?
    let location: Location?
    let current: Current?
    enum CodingKeys: String, CodingKey {
        case request
        case location
        case current
    }
}

// MARK: - DispleyedElement
struct DispleyedElement: Codable {
    let temperature: Int?
    let weatherIcons:String?
    let weatherDescriptions: String?
    let windSpeed: Int?
    let name: String?
}

// MARK: - Current
struct Current: Codable {
    let temperature: Int?
    let weatherIcons: [String]?
    let weatherDescriptions: [String]?
    let windSpeed: Int?

    enum CodingKeys: String, CodingKey {
        case temperature
        case weatherIcons = "weather_icons"
        case weatherDescriptions = "weather_descriptions"
        case windSpeed = "wind_speed"
    }
}

// MARK: - Location
struct Location: Codable {
    let name, country, region, lat: String?
    let lon, timezoneID, localtime: String?
    let localtimeEpoch: Int?
    let utcOffset: String?

    enum CodingKeys: String, CodingKey {
        case name, country, region, lat, lon
        case timezoneID = "timezone_id"
        case localtime
        case localtimeEpoch = "localtime_epoch"
        case utcOffset = "utc_offset"
    }
}

// MARK: - Request
struct Request: Codable {
    let type: String?
}
