//
//  UserDefault+PropertyWrapper.swift
//  YToke
//
//  Created by Lyt on 2020/8/7.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

@propertyWrapper
struct CodableUserDefault<T: Codable> {
    
    private let key: String
    private let defaultValue: T
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let saved = UserDefaults.standard.object(forKey: key) as? Data,
                let decoded = try? decoder.decode(T.self, from: saved) else {
                    return defaultValue
            }
            return decoded
        }
        set {
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}
