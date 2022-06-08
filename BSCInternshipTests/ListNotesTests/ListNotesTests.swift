//
//  ListNotesInteractorTests.swift
//  BSCInternshipTests
//
//  Created by Алексей Саблин on 07.06.2022.
//

import XCTest
@testable import BSCInternship

final class ListNotesTests: XCTestCase {
    let notesInDeviceMock = [
        NoteModel(title: "Заголовок 1", text: "Текст 1", userShareIcon: nil),
        NoteModel(title: "Заголовок 2", text: nil, userShareIcon: nil),
        NoteModel(title: nil, text: "Текст 3", userShareIcon: nil)
    ]

    let notesInWebMock = [
        NoteResponceMo(title: "Заголовок 4", text: "Текст 4", userShareIcon: nil),
        NoteResponceMo(title: "Заголовок 5", text: nil, userShareIcon: nil),
        NoteResponceMo(title: nil, text: "Текст 6", userShareIcon: nil)
    ]

    var formattedNotesInWeb: [NoteResponceMo]!
    var sut: ListNotesInteractor!
    var presenterMock: ListNotesPresenterMock!
    var workerStorageMock: WorkerStorageMock!
    var workerWebMock: WorkerWebMock!

    override func setUp() {
        super.setUp()
        formattedNotesInWeb = [NoteResponceMo]()
        for item in notesInWebMock {
            let note = NoteResponceMo(
                title: item.title,
                text: item.text,
                userShareIcon: item.userShareIcon,
                id: item.id,
                date: item.date
            )
            formattedNotesInWeb.append(note)
        }

        sut = ListNotesInteractor()
        presenterMock = ListNotesPresenterMock()
        workerStorageMock = WorkerStorageMock()
        workerWebMock = WorkerWebMock()
        sut.presenter = presenterMock
        sut.workerStorage = workerStorageMock
        sut.workerWeb = workerWebMock
    }

    override func tearDown() {
        formattedNotesInWeb = nil
        sut = nil
        presenterMock = nil
        workerStorageMock = nil
        workerWebMock = nil
        super.tearDown()
    }

    func testSuccsessGetNotesInStorage() {
        // Given
        let expectation = expectation(description: "Succsess load data in storage")
        workerStorageMock.loadData = notesInDeviceMock
        presenterMock.fetchPresentNotesInStorageResponce = {
            // Then
            XCTAssertTrue(
                self.workerStorageMock.loadWasCalled,
                "Interactor must call workerStorage method \"load\""
            )
            XCTAssertTrue(
                self.presenterMock.presentNotesInStorageWasCalled,
                "The presenter method \"presentNotesInStorage\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentNotesInStorageMock?.notesInDevice == self.notesInDeviceMock)
            expectation.fulfill()
        }
        // When
        sut.getNotesInStorage(request: .init(keyDataSource: "TestingKey"))
        wait(for: [expectation], timeout: 0.5)
    }

    func testCallingWebWorker() {
        // Given
        // When
        sut.getNotesInWeb(request: .init())
        // Then
        XCTAssertTrue(
            self.workerWebMock.fetchWasCalled,
            "Interactor must call workerWeb method \"fetch\""
        )
    }

    func testFailureGetNotesInStorage() {
        // Given
        let expectation = expectation(description: "Failure load data in storage")
        workerStorageMock.loadData = notesInDeviceMock
        presenterMock.fetchPresentNotesInStorageResponce = {
            // Then
            XCTAssertTrue(
                self.workerStorageMock.loadWasCalled,
                "Interactor must call workerStorage method \"load\""
            )
            XCTAssertTrue(
                self.presenterMock.presentNotesInStorageWasCalled,
                "The presenter method \"presentNotesInStorage\" must be called"
            )
            XCTAssertTrue(((self.presenterMock.presentNotesInStorageMock?.notesInDevice.isEmpty) != nil))
            expectation.fulfill()
        }
        // When
        sut.getNotesInStorage(request: .init(keyDataSource: "UndefinedKey"))
        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccsessSaveAllNotes() {
        // Given
        let expectation = expectation(description: "Succsess save data in storage")
        sut.notesInDevice = notesInDeviceMock
        presenterMock.fetchPresentAllSaveNotesResponce = {
            // Then
            XCTAssertTrue(
                self.workerStorageMock.saveWasCalled,
                "Interactor must call workerStorage method \"save\""
            )
            XCTAssertTrue(
                self.presenterMock.presentAllSaveNotesWasCalled,
                "The presenter method \"presentAllSaveNotes\" must be called"
            )
            XCTAssertTrue(self.workerStorageMock.saveData == self.notesInDeviceMock)
            expectation.fulfill()
        }
        // When
        sut.saveAllNotes(request: .init(keyDataSource: "TestingKey"))
        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureSaveAllNotes() {
        // Given
        let expectation = expectation(description: "Failure save data in storage")
        sut.notesInDevice = notesInDeviceMock
        presenterMock.fetchPresentAllSaveNotesResponce = {
            // Then
            XCTAssertTrue(
                self.workerStorageMock.saveWasCalled,
                "Interactor must call workerStorage method \"save\""
            )
            XCTAssertTrue(
                self.presenterMock.presentAllSaveNotesWasCalled,
                "The presenter method \"presentAllSaveNotes\" must be called"
            )
            XCTAssertTrue(self.workerStorageMock.saveData == nil)
            expectation.fulfill()
        }
        // When
        sut.saveAllNotes(request: .init(keyDataSource: "UndefinedKey"))
        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccsessUpdateModel() {
        // Given
        let expectation = expectation(description: "Succsess update model")
        sut.notesInDevice = notesInDeviceMock
        sut.notesInWeb = notesInWebMock
        presenterMock.fetchPresentAllNotesResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentAllNotesWasCalled,
                "The presenter method \"presentAllNotes\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentAllNotesMock?.notesInDevice == self.notesInDeviceMock)
            XCTAssertTrue(self.presenterMock.presentAllNotesMock?.notesInWeb == self.formattedNotesInWeb)
            expectation.fulfill()
        }
        sut.updateModel(request: .init())
        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureUpdateModel() {
        // Given
        let expectation = expectation(description: "Failure update model")
        sut.notesInDevice = []
        sut.notesInWeb = []
        presenterMock.fetchPresentAllNotesResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentAllNotesWasCalled,
                "The presenter method \"presentAllNotes\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentAllNotesMock?.notesInDevice != self.notesInDeviceMock)
            XCTAssertTrue(self.presenterMock.presentAllNotesMock?.notesInWeb != self.formattedNotesInWeb)
            expectation.fulfill()
        }
        // When
        sut.updateModel(request: .init())
        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccsessDeleteNotes() {
        // Given
        var notesInDeviceMockAfterDelete = notesInDeviceMock
        var notesInWebMockAfterDelete = notesInWebMock
        notesInDeviceMockAfterDelete.removeFirst()
        notesInWebMockAfterDelete.removeLast()
        sut.notesInDevice = notesInDeviceMock
        sut.notesInWeb = notesInWebMock
        var deleteNotes = [IndexPath]()
        deleteNotes.append(IndexPath(item: 0, section: 0))
        deleteNotes.append(IndexPath(item: notesInWebMock.count - 1, section: 1))

        let expectation = expectation(description: "Succsess delete notes")
        presenterMock.fetchPresentNotesAfterDeleteResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentNotesAfterDeleteWasCalled,
                "The presenter method \"presentNotesAfterDelete\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentNotesAfterDeleteMock?.notesInDevice == notesInDeviceMockAfterDelete)
            XCTAssertTrue(self.presenterMock.presentNotesAfterDeleteMock?.notesInWeb == notesInWebMockAfterDelete)
            expectation.fulfill()
        }
        // When
        sut.deleteNotes(request: .init(selectedRows: deleteNotes))
        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureDeleteNotes() {
        // Given
        var notesInDeviceMockAfterDelete = notesInDeviceMock
        var notesInWebMockAfterDelete = notesInWebMock
        notesInDeviceMockAfterDelete.removeFirst()
        notesInWebMockAfterDelete.removeLast()
        sut.notesInDevice = notesInDeviceMock
        sut.notesInWeb = notesInWebMock
        var deleteNotes = [IndexPath]()
        deleteNotes.append(IndexPath(item: 0, section: 0))
        deleteNotes.append(IndexPath(item: notesInWebMock.count - 1, section: 0))

        let expectation = expectation(description: "Failure delete notes")
        presenterMock.fetchPresentNotesAfterDeleteResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentNotesAfterDeleteWasCalled,
                "The presenter method \"presentNotesAfterDelete\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentNotesAfterDeleteMock?.notesInDevice != notesInDeviceMockAfterDelete)
            XCTAssertTrue(self.presenterMock.presentNotesAfterDeleteMock?.notesInWeb != notesInWebMockAfterDelete)
            expectation.fulfill()
        }
        // When
        sut.deleteNotes(request: .init(selectedRows: deleteNotes))
        wait(for: [expectation], timeout: 0.5)
    }
}
