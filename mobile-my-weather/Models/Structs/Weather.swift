//
//  Weather.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


struct Weather: Hashable, Codable {
    var date: String
    var city: City
    var temperature: Int
    var humidity: Int
    var description: String
}
