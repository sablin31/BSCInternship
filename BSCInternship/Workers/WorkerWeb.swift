//
//  WorkerStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 16.05.2022.
//
//  Worker - fetch data in Json

import Foundation

protocol NetworkServiceProtocol {
    func fetch(url: URL?, completion: @escaping (Result<[NoteInWeb]?, Error>) -> Void)
}

struct WorkerWeb: NetworkServiceProtocol {
    // MARK: - Public methods

    func fetch(url: URL?, completion: @escaping ((Result<[NoteInWeb]?, Error>) -> Void)) {
        guard let url = url else { return }

        URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let notes = try JSONDecoder().decode([NoteInWeb].self, from: data)
                completion(.success(notes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
