//
//  WorkerWebMock.swift
//  BSCInternshipTests
//
//  Created by Алексей Саблин on 07.06.2022.
//

import Foundation
@testable import BSCInternship

final class WorkerWebMock: NetworkServiceProtocol {
    var fetchWasCalled = false

    func fetch(url: URL?, completion: @escaping (Result<[NoteInWeb]?, Error>) -> Void) {
        fetchWasCalled = true
        return
    }
}
