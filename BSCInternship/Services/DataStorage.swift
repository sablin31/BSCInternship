//
//  DataStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import Foundation

class DataStorage {
    private var storage = UserDefaults.standard

    func load(key: String) -> String {
        return storage.string(forKey: key) ?? ""
    }
    
    func save(data: String, key: String) {
        storage.set(data, forKey: key)
    }
}
