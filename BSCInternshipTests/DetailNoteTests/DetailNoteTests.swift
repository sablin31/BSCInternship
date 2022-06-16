//
//  DetailNoteTests.swift
//  BSCInternshipTests
//
//  Created by Алексей Саблин on 08.06.2022.
//

import XCTest
@testable import BSCInternship

final class DetailNoteTests: XCTestCase {
    var currentNote: NoteModel!
    var sut: DetailNoteInteractor!
    var presenterMock: DetailNotePresenterMock!

    override func setUp() {
        super.setUp()
        currentNote = NoteModel(
            title: "Тестовый заголовок",
            text: "Тестовый текст",
            userShareIcon: nil
        )
        sut = DetailNoteInteractor()
        presenterMock = DetailNotePresenterMock()
        sut.presenter = presenterMock
    }

    override func tearDown() {
        sut = nil
        presenterMock = nil
        currentNote = nil
        super.tearDown()
    }

    func testSuccsessGetCurrentNote() {
        // Given
        let expectation = expectation(description: "Succsess get current note")
        sut.currentNote = currentNote

        presenterMock.fetchPresentCurrentNoteResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentCurrentNoteWasCalled,
                "The presenter method \"presentCurrentNote\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentCurrentNoteMock?.currentNote == self.currentNote)
            expectation.fulfill()
        }
        // When
        sut.getCurrentNote(request: .init())
        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureGetCurrentNote() {
        // Given
        let expectation = expectation(description: "Failure get currentNote")

        presenterMock.fetchPresentCurrentNoteResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentCurrentNoteWasCalled,
                "The presenter method \"presentCurrentNote\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentCurrentNoteMock?.currentNote == nil)
            expectation.fulfill()
        }
        // When
        sut.getCurrentNote(request: .init())
        wait(for: [expectation], timeout: 0.5)
    }

    func testSuccsessUpdateCurrentNote() {
        // Given
        let expectation = expectation(description: "Succsess update current note")
        sut.currentNote = currentNote
        let updateTitle = "Новый заголовок"
        let updateText = "Новый текст"

        presenterMock.fetchPresentModifierCurrentNoteResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentModifierCurrentNoteWasCalled,
                "The presenter method \"presentModifierCurrentNote\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentModifierNoteMock?.currentNote?.title == updateTitle)
            XCTAssertTrue(self.presenterMock.presentModifierNoteMock?.currentNote?.text == updateText)
            expectation.fulfill()
        }
        // When
        sut.updateModel(
            request: .init(
                title: updateTitle,
                text: updateText
            )
        )
        wait(for: [expectation], timeout: 0.5)
    }

    func testFailureUpdateCurrentNote() {
        // Given
        let expectation = expectation(description: "Failure update current note")
        sut.currentNote = currentNote
        let updateTitle = "Новый заголовок"
        let updateText = "Новый текст"

        presenterMock.fetchPresentModifierCurrentNoteResponce = {
            // Then
            XCTAssertTrue(
                self.presenterMock.presentModifierCurrentNoteWasCalled,
                "The presenter method \"presentModifierCurrentNote\" must be called"
            )
            XCTAssertTrue(self.presenterMock.presentModifierNoteMock?.currentNote?.title != updateTitle)
            XCTAssertTrue(self.presenterMock.presentModifierNoteMock?.currentNote?.text != updateText)
            expectation.fulfill()
        }
        // When
        sut.updateModel(
            request: .init(
                title: nil,
                text: nil
            )
        )
        wait(for: [expectation], timeout: 0.5)
    }
}
