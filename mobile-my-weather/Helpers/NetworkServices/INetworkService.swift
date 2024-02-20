//
//  INetworkService.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


protocol INetworkService {
    func updateDataWith(cityName: String)
    func updateDataWith(latitude: Double, longitude: Double)
}
