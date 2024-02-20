//
//  City.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


struct City: Hashable, Codable {
    var id: Int
    var name: String
    var coordinates: Coordinates
}
