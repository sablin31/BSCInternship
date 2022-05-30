//
//  WorkerStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import Foundation

// MARK: - UserDefaultsService protocol

protocol UserDefaultsServiceProtocol {
    func loadNotes() -> [Note]?
    func saveNotes(notes: [Note])
}
// MARK: - Data in UserDefaults

class WorkerStorage: UserDefaultsServiceProtocol {
    // MARK: - Private properties

    private var storage = UserDefaults.standard
    // MARK: - Public Methods

    func loadNotes() -> [Note]? {
        var notes: [Note]?
        if let data = storage.data(forKey: Constants.key) {
            do {
                notes = try JSONDecoder().decode([Note].self, from: data)
            } catch {
                print("\(Constants.errorDecodeDescription) (\(error))")
            }
        }
        return notes
    }

    func saveNotes(notes: [Note]) {
        do {
            let data = try JSONEncoder().encode(notes)
            storage.set(data, forKey: Constants.key)
        } catch {
            print(" \(Constants.errorEncodeDescription) (\(error))")
        }
    }
}
// MARK: - Constants

extension WorkerStorage {
    private enum Constants {
        // MARK: Data source key

        static let key = "notes"

        // MARK: String constants

        static let errorEncodeDescription = "Unable to Encode Note"
        static let errorDecodeDescription = "Unable to Decode Note"
    }
}
