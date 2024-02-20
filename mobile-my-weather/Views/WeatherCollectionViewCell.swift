//
//  WeatherCollectionViewCell.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import SnapKit


private enum Constants {
    
    enum Fonts {
        static let dateLabel: UIFont = UIFont.systemFont(ofSize: 23)
        static let temperatureLabel: UIFont = UIFont.systemFont(ofSize: 43)
        static let descriptionLabel: UIFont = UIFont.systemFont(ofSize: 17)
        static let humidityLabel: UIFont = UIFont.systemFont(ofSize: 15)
    }
    
    enum Heights {
        static let dateLabel: CGFloat = 43
        static let temperatureLabel: CGFloat = 65
        static let descriptionLabel: CGFloat = 23
        static let humidityLabel: CGFloat = 21
    }
    
}


final class WeatherCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.Fonts.dateLabel
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.Fonts.temperatureLabel
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.Fonts.descriptionLabel
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.Fonts.humidityLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func configure(with weather: Weather) {
        dateLabel.text = DateConverter.convertedToCell(with: weather.date)
        temperatureLabel.text = " \(weather.temperature)°"
        descriptionLabel.text = weather.description
        humidityLabel.text = "Humidity: \(weather.humidity)%"
    }
    
    
    // MARK: - Private
    private func setupCell() {
        addBlackBackground()
        setupLabels()
    }
    
    private func setupLabels() {
        setupDateLabel()
        setupTemperatureLabel()
        setupDescriptionLabel()
        setupHumidityLabel()
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Constants.Heights.dateLabel)
        }
    }
    
    private func setupTemperatureLabel() {
        contentView.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.Heights.temperatureLabel)
        }
    }
    
    private func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.Heights.descriptionLabel)
        }
    }
    
    private func setupHumidityLabel() {
        contentView.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.Heights.humidityLabel)
        }
    }
    
}
