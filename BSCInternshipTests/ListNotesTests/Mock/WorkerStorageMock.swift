//
//  WorkerStorageMock.swift
//  BSCInternshipTests
//
//  Created by Алексей Саблин on 07.06.2022.
//

import Foundation
@testable import BSCInternship

final class WorkerStorageMock: DataSourceServiceProtocol {
    var loadWasCalled = false
    var saveWasCalled = false
    var key = "TestingKey"
    var loadData: [NoteModel] = []
    var saveData: [NoteModel]?

    func loadDate(key: String) -> [NoteModel]? {
        loadWasCalled = true
        return self.key == key ? loadData : []
    }

    func save(notes: [NoteModel], key: String) {
        saveWasCalled = true
        if self.key == key {
            saveData = notes
        }
    }
}
