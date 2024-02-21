//
//  LocationsManager.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


private enum Constants {
    static let key: String = "LocationsManagerCitiesKey"
    
}

final class LocationsManager {
    
    private let belarusCities = [
        "Minsk",
        "Brest",
        "Hrodna",
        "Gomel",
        "Mogilev",
        "Vitebsk",
        "Baranovichi",
        "Bobruisk",
        "Pinsk",
        "Orsha",
        "Molodechno",
        "Lida",
        "Novopolotsk",
        "Soligorsk",
        "Mozyr",
        "Slutsk",
        "Polotsk",
        "Kobrin",
        "Svetlogorsk",
        "Rechitsa"
    ]
    
    func searchCitiesBy(text searchText: String) -> [String] {
        belarusCities.compactMap{ $0.contains(searchText) ? $0 : nil }.filter { !$0.isEmpty }
    }
    
    
    func addCity(with cityName: String) {
        var cities = load()
        if cities.contains(cityName) { return }
        cities.append(cityName)
        save(with: cities)
    }
    
    func removeCity(with cityName: String) {
        var cities = load()
        if let index = cities.firstIndex(of: cityName) {
            cities.remove(at: index)
        }
        save(with: cities)
    }
    
    func load() -> [String] {
        let cities = UserDefaults.standard.array([String].self, forKey: Constants.key)
        if cities.isEmpty { return [GlobalConstants.myLocation] }
        return cities
    }
    
    func save(with cities: [String]) {
        UserDefaults.standard.setArray(encodableArray: cities, forKey: Constants.key)
    }
    
}
