//
//  UserDefaults+extensions.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 19.02.24.
//

import Foundation


extension UserDefaults {
    // MARK: - Save data
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func setArray<T: Encodable>(encodableArray: [T], forKey key: String) {
        if let data = try? JSONEncoder().encode(encodableArray) {
            set(data, forKey: key)
        }
    }
    
    // MARK: - Load data
    func object<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
    func array<T: Decodable>(_ type: [T].Type, forKey key: String) -> [T] {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return []
    }
    
}
