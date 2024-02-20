//
//  SearchCityContainerView.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 20.02.24.
//

import SnapKit


private enum Constants {
    static let font: UIFont = .boldSystemFont(ofSize: 21)
    static let spacing: CGFloat = 10
    
}

final class SearchCityContainerView: UITableViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    private let cityNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = Constants.font
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addBlackBackground(isRadius: false)
        setupTitle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with city: String) {
        cityNameLabel.text = city
    }
    
    private func setupTitle() {
        contentView.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.spacing)
            make.left.equalToSuperview().offset(Constants.spacing)
            make.right.equalToSuperview().offset(-Constants.spacing)
            make.bottom.equalToSuperview().offset(-Constants.spacing)
        }
    }
    
}
