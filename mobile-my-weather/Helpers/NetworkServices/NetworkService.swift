//
//  NetworkService.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation
import RxSwift
import RxRelay


private extension String {
    static let baseURL = "http://api.openweathermap.org/data/2.5"
    static let appid = "64c8067644c1f584904e1e80cda9303e"
    static let id = "524901"
}

private enum APIPath: String {
    case forecast = "/forecast"
}

private enum RequestType: String {
    case GET
    case POST
}

final class NetworkService: INetworkService {
    
    private weak var behaviorRelay: BehaviorRelay<[Weather]>?
    private let numberOfDaysForForecast: Int
    
    init(with behaviorRelay: BehaviorRelay<[Weather]>?, numberOfDaysForForecast: Int) {
        self.behaviorRelay = behaviorRelay
        self.numberOfDaysForForecast = numberOfDaysForForecast
    }
    
    func updateDataWith(cityName: String) {
        var endpoint = URLComponents()
        endpoint.path = APIPath.forecast.rawValue
        endpoint.queryItems = [
            URLQueryItem(name: "appid", value: "64c8067644c1f584904e1e80cda9303e"),
            URLQueryItem(name: "id", value: "524901"),
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "q", value: cityName)
        ]
        
        sendRequest(with: endpoint.string, requestType: .GET) { [weak self] schedule in
            self?.behaviorRelay?.accept(schedule)
        }
    }
    
    func updateDataWith(latitude: Double, longitude: Double) {
        var endpoint = URLComponents()
        endpoint.path = APIPath.forecast.rawValue
        endpoint.queryItems = [
            URLQueryItem(name: "appid", value: "64c8067644c1f584904e1e80cda9303e"),
            URLQueryItem(name: "id", value: "524901"),
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
        ]
        
        sendRequest(with: endpoint.string, requestType: .GET) { [weak self] schedule in
            self?.behaviorRelay?.accept(schedule)
        }
    }
    
    private func sendRequest(with endpoint: String?, requestType: RequestType, completion: @escaping ([Weather]) -> Void) {
        guard let endpoint else { return }
        guard let url = URL(string: .baseURL + endpoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let schedule = JSONConverter.toArray(with: json) else { return }
            completion(self.getNumbersDayForecast(with: schedule))
        }
        
        task.resume()
    }
    
    private func getNumbersDayForecast(with schedule: [Weather]) -> [Weather] {
        var uniqueDates = [String]()
        var firstNumbersUniqueDates = [Weather]()

        for weather in schedule {
            let dateComponents = weather.date.components(separatedBy: " ")
            let date = dateComponents[0] // Extract the date part from the datetime string
            
            if !uniqueDates.contains(date) {
                uniqueDates.append(date)
                firstNumbersUniqueDates.append(weather)
            }
            
            if firstNumbersUniqueDates.count == numberOfDaysForForecast {
                break // Exit the loop once we have the first NumberOfDaysForForecast unique dates
            }
        }
        
        return firstNumbersUniqueDates
    }
    
}
