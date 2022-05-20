//
//  WorkerStorage.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 16.05.2022.
//

import Foundation

// MARK: - Data in JSON

class WorkerWeb {
    // MARK: - Private proterties

    private let session: URLSession

    private enum ErrorList: Error {
        case urlNotFound
        case unknownError
    }
    // MARK: - Init

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    // MARK: - Public Methods

    func fetch(completion: @escaping ([NoteInWeb]?) -> Void) {
        do {
            session.dataTask(with: try createURLRequest()) { data, _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error recived request data: \(error.localizedDescription)")
                        return
                    }
                    guard let data = data else { return }
                    do {
                        let notes = try JSONDecoder().decode([NoteInWeb].self, from: data)
                        completion(notes)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                    }
                }
            }
            .resume()
        } catch ErrorList.urlNotFound {
            print("URL is not found")
        } catch {
            print("Unknown error")
        }
    }
}
// MARK: - Private Methods

private extension WorkerWeb {
    func createURLRequest() throws -> URLRequest {
        guard let url = createURLComponents() else { throw ErrorList.urlNotFound }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    func createURLComponents() -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/Empty.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "d07f7d4a-141e-4ac5-a2d2-cc936d4e6f18")
        ]
        return urlComponents.url
    }
}
