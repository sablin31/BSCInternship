//
//  WorkerStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import Foundation

// MARK: - Data in UserDefaults

class WorkerStorage {
    // MARK: - Private proterties

    private var storage = UserDefaults.standard
    // MARK: - Public Methods

    func loadDate(key: String) -> [Note]? {
        var notes: [Note]?
        if let data = storage.data(forKey: key) {
            do {
                notes = try JSONDecoder().decode([Note].self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return notes
    }

    func save(notes: [Note], key: String) {
        do {
            let data = try JSONEncoder().encode(notes)
            storage.set(data, forKey: key)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
}
