//
//  DataStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import Foundation

class DataStorage {
    private var storage = UserDefaults.standard

    func loadDate(key: String) -> [NoteProtocol]? {
        return storage.array(forKey: key) as? [NoteProtocol]
    }

    func save(notes: [NoteProtocol], key: String) {
        storage.set(notes, forKey: key)
    }
}
