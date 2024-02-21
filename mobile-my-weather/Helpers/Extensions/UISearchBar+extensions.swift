//
//  UISearchBar+extensions.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 18.02.24.
//

import SnapKit


private enum Constants {
    static let placeholder: String = "Search by city name"
}

extension UISearchBar {
    
    func setupSearchBarForWeatherForecastByCityName() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundImage = UIImage()
        backgroundColor = .clear
        barTintColor = .clear
        if let searchTextField = self.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = .white
            searchTextField.placeholder = Constants.placeholder
        }
        
    }
    
}
