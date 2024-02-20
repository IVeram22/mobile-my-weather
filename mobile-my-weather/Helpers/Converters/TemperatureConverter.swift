//
//  TemperatureConverter.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


final class TemperatureConverter {
    
    static func toCelsiusFrom(kelvin temperature: Double) -> Int {
        Int(temperature - 273.15)
    }
    
}
