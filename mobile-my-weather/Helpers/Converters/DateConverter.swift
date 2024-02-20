//
//  DateConverter.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


private enum Constants {
    static let dateFormat: String = "yyyy-MM-dd HH:mm:ss"
}

private enum DateConverterFormats: String {
    case Standard = "yyyy-MM-dd hh:mm:ss a"
    case Cell = "EEE"
    case Title = "EEEE, MMM d"
}

final class DateConverter {
    
    static func convertedToStandard(with dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = Constants.dateFormat

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = DateConverterFormats.Standard.rawValue
            return dateFormatter.string(from: date)
        }
        
        return dateString
    }
    
    static func convertedToCell(with dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateConverterFormats.Standard.rawValue
        
        if let date = dateFormatter.date(from: dateString) {
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = DateConverterFormats.Cell.rawValue
            let dayOfWeekString = dayOfWeekFormatter.string(from: date)
            if dayOfWeekString == getCurrentDay() { return "Today" }
            return dayOfWeekString // Output: "Mon"
        }
        
        return dateString
    }
    
    static func convertedToTitle(with dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateConverterFormats.Standard.rawValue

        if let date = dateFormatter.date(from: dateString) {
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = DateConverterFormats.Title.rawValue
            let dayOfWeekString = dayOfWeekFormatter.string(from: date)
            return dayOfWeekString // Output: "Mon"
        }
        
        return dateString
    }
    
    private static func getCurrentDay() -> String {
        let currentDate = Date()
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = DateConverterFormats.Cell.rawValue
        let dayOfWeekString = dayOfWeekFormatter.string(from: currentDate)
        return dayOfWeekString // Output: "Mon"
    }
    
}
