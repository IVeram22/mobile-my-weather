//
//  ViewModel.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import RxSwift
import RxRelay


final class ViewModel {
    
    private let locationsManager = LocationsManager()
    
    let behaviorRelay: BehaviorRelay<[Weather]>
    let searchBehaviorRelay: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    private let networkService: INetworkService
    
    init() {
        behaviorRelay = BehaviorRelay(value: [])
        networkService = NetworkService(
            with: self.behaviorRelay,
            numberOfDaysForForecast: GlobalConstants.numberOfDaysForForecast
        )
        behaviorRelay.subscribe { [weak self] event in
            guard let schedule = event.element else { return }
            guard !schedule.isEmpty else { return }
            self?.locationsManager.addCity(with: schedule[0].city.name)
        }.disposed(by: disposeBag)
    }
    
    func getLocations() -> [String] {
        locationsManager.load()
    }
    
    func addCity(with cityName: String) {
        networkService.updateDataWith(cityName: cityName)
    }
    
    func searchCitiesBy(text searchText: String) {
        searchBehaviorRelay.accept(locationsManager.searchCitiesBy(text: searchText))
    }
    
}
