//
//  DataStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import Foundation

// MARK: - Save data to UserDefaults

class DataStorage {
    private var storage = UserDefaults.standard

    func loadDate(key: String) -> [Note]? {
        var notes: [Note]?
        // Read Data from UserDefaults
        if let data = storage.data(forKey: key) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                notes = try decoder.decode([Note].self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return notes
    }

    func save(notes: [Note], key: String) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(notes)

            // Write Data to UserDefaults
            storage.set(data, forKey: key)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
}
