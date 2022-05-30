import Foundation

// MARK: - NetworkService protocol

protocol NetworkServiceProtocol {
    func getNotes(completion: @escaping (Result<[NoteInWeb]?, Error>) -> Void)
}
// MARK: - Data in web

struct WorkerWeb: NetworkServiceProtocol {
    // MARK: - Public methods

    func getNotes(completion: @escaping ((Result<[NoteInWeb]?, Error>) -> Void)) {
        guard let url = createURLComponents() else { return }

        URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let obj = try JSONDecoder().decode([NoteInWeb].self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
// MARK: - Private Methods

private extension WorkerWeb {
    func createURLComponents() -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.path
        urlComponents.queryItems = [
            Constants.queryAlt,
            Constants.queryToken
        ]
        return urlComponents.url
    }
}
// MARK: - Constants

extension WorkerWeb {
    private enum Constants {
        // MARK: Url components constants - JSON Notes
        static let scheme = "https"
        static let host = "firebasestorage.googleapis.com"
        static let path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
        static let queryAlt = URLQueryItem(name: "alt", value: "media")
        static let queryToken = URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
    }
}
