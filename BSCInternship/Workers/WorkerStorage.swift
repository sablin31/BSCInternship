//
//  WorkerStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//
//  Worker - fetch data in UserDefaults

import Foundation

protocol DataSourceServiceProtocol {
    func loadDate(key: String) -> [NoteModel]?
    func save(notes: [NoteModel], key: String)
}

struct WorkerStorage: DataSourceServiceProtocol {
    // MARK: - Private proterties

    private var storage = UserDefaults.standard
    // MARK: - Public Methods

    func loadDate(key: String) -> [NoteModel]? {
        var notes: [NoteModel]?
        if let data = storage.data(forKey: key) {
            do {
                notes = try JSONDecoder().decode([NoteModel].self, from: data)
            } catch {
                print("\(Constants.decodeErrorDescription) (\(error))")
            }
        }
        return notes
    }

    func save(notes: [NoteModel], key: String) {
        do {
            let data = try JSONEncoder().encode(notes)
            storage.set(data, forKey: key)
        } catch {
            print("\(Constants.encodeErrorDescription) (\(error))")
        }
    }
}
// MARK: - Constants

extension WorkerStorage {
    private enum Constants {
        static let decodeErrorDescription = "Unable to Decode Note"
        static let encodeErrorDescription = "Unable to Decode Note"
    }
}
