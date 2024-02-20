//
//  ForecastViewModel.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import RxRelay


final class ForecastViewModel {
    
    let behaviorRelay: BehaviorRelay<[Weather]>
    private let networkService: INetworkService
    
    private let locationsManager = LocationsManager()
    
    init() {
        behaviorRelay = BehaviorRelay(value: [])
        networkService = NetworkService(
            with: self.behaviorRelay,
            numberOfDaysForForecast: GlobalConstants.numberOfDaysForForecast
        )
    }
    
    func updateDataWith(cityName city: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.networkService.updateDataWith(cityName: city)
        }
        
    }
    
    func updateDataWith(latitude lat: Double, longitude lon: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.networkService.updateDataWith(latitude: lat, longitude: lon)
        }
    }
    
    func removeCity(with cityName: String) {
        locationsManager.removeCity(with: cityName)
    }
    
}
