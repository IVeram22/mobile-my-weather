//
//  UIView+extensions.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 18.02.24.
//

import SnapKit


private enum Constants {
    static let radius: CGFloat = 10
    
    enum Background {
        static let color: UIColor = .black
        static let alpha: CGFloat = 0.5
    }
    
}

extension UIView {
    
    func cornerRadius(with radius: CGFloat = Constants.radius) {
        layer.cornerRadius = radius
    }
    
    func addBlackBackground(isRadius: Bool = true) {
        let background = UIView(frame: self.bounds)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = Constants.Background.color
        background.alpha = Constants.Background.alpha
        if isRadius { background.cornerRadius() }
        addSubview(background)
        background.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
}
