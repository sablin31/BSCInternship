//
//  DataStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import Foundation

class DataStorage {
    private var storage = UserDefaults.standard

    func loadDate(key: String) -> NoteProtocol? {
        var note: NoteProtocol?
        // Read Data from UserDefaults
        if let data = storage.data(forKey: "note") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                note = try decoder.decode(Note.self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return note
    }

    func save(note: NoteProtocol, key: String) {
        guard let noteToRecord = note as? Note else { return }
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(noteToRecord)

            // Write Data to UserDefaults
            storage.set(data, forKey: "note")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
}
