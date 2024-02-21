//
//  ForecastViewController.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import SnapKit
import MapKit
import RxSwift


private enum Constants {
    static let spacing: CGFloat = 20
    static let numberOfCells: CGFloat = 2
    
    enum CollectionView {
        static let height: CGFloat = 355
    }
    
    enum CityContainerView {
        static let top: CGFloat = 110
        static let height: CGFloat = 135
    }
    
}

class ForecastViewController: UIViewController {
    
    private let viewModel = ForecastViewModel()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    private var cityContainerView = CityContainerView(frame: .zero)
    private var map = MKMapView()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var schedule: [Weather] = []
    private var isMyLocation: Bool = false
    private var cityName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateData()
    }
    
    func configure(with cityName: String, isMyLocation: Bool = false) {
        self.isMyLocation = isMyLocation
        self.cityName = cityName
    }
    
    // MARK: - Private
    private func setupViewController() {
        setupSubscribes()
        setupLocationManager()
        setupMap()
        setupCollectionView()
        setupCityContainerView()
        setupTrashButton()
    }
    
    private func setupSubscribes() {
        viewModel.behaviorRelay.subscribe { event in
            guard let schedule = event.element else { return }
            guard !schedule.isEmpty else { return }
            self.updateCityContainerView(with: schedule[0])
        }.disposed(by: disposeBag)
        
        viewModel.behaviorRelay.subscribe { event in
            guard let schedule = event.element else { return }
            guard !schedule.isEmpty else { return }
            self.updateCollectionView(with: Array(schedule))
            self.map.setupCamera(CLLocation(
                latitude: schedule[0].city.coordinates.latitude,
                longitude: schedule[0].city.coordinates.latitude
            ))
        }.disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        guard isMyLocation else { return }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
    }
    
    private func setupMap() {
        map = MKMapView(frame: view.bounds)
        view.addSubview(map)
        map.mapType = .satelliteFlyover
        map.showsUserLocation = false
        map.showsCompass = false
        map.showsScale = false
        map.addBlackBackground()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            WeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier
        )
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(
                Constants.CityContainerView.top
                + Constants.CityContainerView.height
                + Constants.spacing
            )
            make.left.equalToSuperview().offset(Constants.spacing)
            make.right.equalToSuperview().offset(-Constants.spacing)
            make.height.equalTo(Constants.CollectionView.height)
        }
    }
    
    
    private func setupCityContainerView() {
        view.addSubview(cityContainerView)
        cityContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.CityContainerView.top)
            make.left.equalToSuperview().offset(Constants.spacing)
            make.right.equalToSuperview().offset(-Constants.spacing)
            make.height.equalTo(Constants.CityContainerView.height)
        }
        
    }
    
    private func updateCityContainerView(with weather: Weather) {
        DispatchQueue.main.async {
            self.map.setupCamera(CLLocation(
                latitude: weather.city.coordinates.latitude,
                longitude: weather.city.coordinates.longitude
            ))
            self.cityContainerView.configure(with: weather)
        }
    }
    
    private func updateCollectionView(with schedule: [Weather]) {
        DispatchQueue.main.async {
            self.schedule = schedule
            self.collectionView.reloadData()
        }
    }
    
    private func setupTrashButton() {
        guard !isMyLocation else { return }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .done,
            target: self,
            action: #selector(removeForecast)
        )
    }
    
    private func updateData() {
        switch isMyLocation {
        case true:
            locationManager.startUpdatingLocation()
        default:
            viewModel.updateDataWith(cityName: cityName)
        }
    }
    
    @objc private func removeForecast() {
        viewModel.removeCity(with: cityName)
        navigationController?.popToRootViewController(animated: true)
    }
    
}


// MARK: - Extensions
extension ForecastViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        viewModel.updateDataWith(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        map.setupCamera(location)
        locationManager.stopUpdatingLocation()
    }
    
}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        schedule.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as? WeatherCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: schedule[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - Constants.spacing) / Constants.numberOfCells
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
