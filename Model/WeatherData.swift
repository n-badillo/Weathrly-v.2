//
//  WeatherData.swift
//  Clima
//
//  Created by CSUFTitan on 3/28/20.
//  Copyright © 2020 Nancy Badillo. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int  // Inside the weather[0].id
    let description: String
    
}

// If you want to encode data back inoto JSON, you can use Encodeable
// If you want both decodeabl and encodable data, you can use Codeable
