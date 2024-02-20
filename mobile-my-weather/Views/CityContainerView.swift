//
//  CityContainerView.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import SnapKit


private enum Constants {
    
    enum Fonts {
        static let cityName: UIFont = UIFont.systemFont(ofSize: 43)
        static let date: UIFont = UIFont.systemFont(ofSize: 23)
    }
    
    enum CityNameLabel {
        static let centerY: CGFloat = -23
        static let height: CGFloat = 55
    }
    
    enum DateLabel {
        static let height: CGFloat = 55
    }
    
}

final class CityContainerView: UIView {
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.Fonts.cityName
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.Fonts.date
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func configure(with weather: Weather) {
        isHidden = false
        cityNameLabel.text = weather.city.name
        dateLabel.text = DateConverter.convertedToTitle(with: weather.date)
    }
    
    // MARK: - Private
    private func setupContainer() {
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        cornerRadius()
        addBlackBackground()
        setupLabels()
    }
    
    private func setupLabels() {
        setupCityNameLabel()
        setupDateLabel()
    }
    
    private func setupCityNameLabel() {
        addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.CityNameLabel.centerY)
            make.height.equalTo(Constants.CityNameLabel.height)
        }
    }
    
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Constants.DateLabel.height)
        }
    }
    
}
