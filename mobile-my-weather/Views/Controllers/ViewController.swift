//
//  ViewController.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 18.02.24.
//

import SnapKit
import MapKit
import RxSwift


private enum Constants {
    static let duration: TimeInterval = 1
    
    enum SearchBar {
        static let height: CGFloat = 55
    }
    
    enum LocationsTable {
        static let heightForRow: CGFloat = 125
        static let heightForSearchRow: CGFloat = 55
        
        enum Constraints {
            static let spacing: CGFloat = 10
        }
    }
    
}

final class ViewController: UIViewController {
    
    private var map = MKMapView()
    private let searchBar = UISearchBar(frame: .zero)
    private let locationsTable = UITableView(frame: .zero)
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    private var locations: [String] = []
    
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        map.setCameraToPlanet()
        updateLocations()
    }
    
    private func setupUserInterface() {
        setupSubscribes()
        setupMap()
        setupSearchBar()
        setupLocationsTable()
    }
    
    private func setupSubscribes() {
        viewModel.behaviorRelay.subscribe { [weak self] event in
            guard let self else { return }
            guard let schedule = event.element else { return }
            guard !schedule.isEmpty else { return }
            self.updateLocations()
        }.disposed(by: disposeBag)
        
        viewModel.searchBehaviorRelay.subscribe { [weak self] event in
            guard let self else { return }
            guard let cities = event.element else { return }
           
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.locations = cities
                self.locationsTable.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupMap() {
        map = MKMapView(frame: view.bounds)
        view.addSubview(map)
        map.mapType = .satelliteFlyover
        map.showsUserLocation = false
        map.showsCompass = false
        map.showsScale = false
        map.addBlackBackground()
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    private func setupSearchBar() {
        searchBar.setupSearchBarForWeatherForecastByCityName()
        
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.SearchBar.height)
        }
    }
    
    private func setupLocationsTable() {
        locationsTable.setDefaultSetting()
        locationsTable.delegate = self
        locationsTable.dataSource = self
        locationsTable.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        
        locationsTable.register(SearchCityContainerView.self, forCellReuseIdentifier: SearchCityContainerView.identifier)
        
        view.addSubview(locationsTable)
        locationsTable.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.bottom.equalToSuperview().offset(Constants.LocationsTable.Constraints.spacing)
            make.right.bottom.equalToSuperview().offset(-Constants.LocationsTable.Constraints.spacing)
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateLocations() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.locations = self.viewModel.getLocations()
            self.locationsTable.reloadData()
        }
    }
    
    private func showWeatherDisplayConfirmation(with cityName: String) {
        let alert = UIAlertController(
            title: "Adding weather forecast for \(cityName)",
            message: "Do you want to track the weather in \(cityName)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            self?.viewModel.addCity(with: cityName)
            self?.showLocations()
            self?.navigeteToForecast(with: cityName)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.showLocations()
        }))
        
        alert.addAction(UIAlertAction(title: "Show forecast only", style: .destructive, handler: { [weak self] _ in
            self?.showLocations()
            self?.navigeteToForecast(with: cityName, isPresent: true)
        }))
        
        present(alert, animated: true)
    }
    
    private func showLocations() {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        isSearching = false
        updateLocations()
    }
    
    private func hideLocations() {
        self.searchBar.showsCancelButton = true
        isSearching = true
    }
    
    private func navigeteToForecast(with cityName: String, isPresent: Bool = false) {
        let controller = ForecastViewController()
        controller.configure(with: cityName)
        if isPresent {
            present(controller, animated: true)
        } else {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc private func hideKeyboard() {
        showLocations()
    }
    
}

// MARK: SearchBar
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hideLocations()
        isSearching = true
        viewModel.searchCitiesBy(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showLocations()
        isSearching = false
    }
    
}

// MARK: TextField
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let cityName = textField.text else { return false }
        showWeatherDisplayConfirmation(with: cityName)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hideLocations()
        return true
    }
    
}

// MARK: TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch isSearching {
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCityContainerView.identifier, for: indexPath) as? SearchCityContainerView else { return UITableViewCell() }
            cell.configure(with: locations[indexPath.row])
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }
            cell.configure(with: locations[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch isSearching {
        case true:
            return Constants.LocationsTable.heightForSearchRow
        default:
            return Constants.LocationsTable.heightForRow
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch isSearching {
        case true:
            showWeatherDisplayConfirmation(with: locations[indexPath.row])
        default:
            let forecast = ForecastViewController()
            let isMyLocation: Bool = locations[indexPath.row] == GlobalConstants.myLocation ? true : false
            forecast.configure(with: locations[indexPath.row], isMyLocation: isMyLocation)
            navigationController?.pushViewController(forecast, animated: true)
        }
    }
    
}
