//
//  JSONConverter.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


final class JSONConverter {
    
    static func toArray(with json: [String : Any]) -> [Weather]? {
        var schedule: [Weather]? = nil
        
        guard let city = json["city"] as? [String: Any] else { return nil }
        guard let coord = city["coord"] as? [String: Any] else { return nil }
        guard let latitude = coord["lat"] as? Double else { return nil }
        guard let longitude = coord["lon"] as? Double else { return nil }
        guard let id = city["id"] as? Int else { return nil }
        guard let name = city["name"] as? String else { return nil }
        
        let currentCity = City(
            id: id,
            name: name,
            coordinates: Coordinates(
                latitude: latitude,
                longitude: longitude
            )
        )
        
        guard let list = json["list"] as? [[String: Any]] else { return nil }
        
        schedule = []
        
        for index in 0..<list.count {
            let object = list[index]
            
            guard let dateString = object["dt_txt"] as? String else { return nil }
            guard let weather = object["weather"] as? [[String: Any]] else { return nil }
            guard let description = weather[0]["description"] as? String else { return nil }
            guard let main = object["main"] as? [String: Any] else { return nil }
            guard let temperature = main["temp"] as? Double else { return nil }
            guard let humidity = main["humidity"] as? Int else { return nil }

            schedule?.append(Weather(
                date: DateConverter.convertedToStandard(with: dateString),
                city: currentCity,
                temperature: TemperatureConverter.toCelsiusFrom(kelvin: temperature),
                humidity: humidity,
                description: description.capitalized
            ))
            
        }
        
        return schedule
    }
    
}
