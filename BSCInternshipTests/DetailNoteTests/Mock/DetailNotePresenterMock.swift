//
//  DetailNotePresenterMock.swift
//  BSCInternshipTests
//
//  Created by Алексей Саблин on 08.06.2022.
//

import Foundation
@testable import BSCInternship

final class DetailNotePresenterMock: DetailNotePresentationLogic {
    var presentCurrentNoteWasCalled = false
    var presentModifierCurrentNoteWasCalled = false

    var presentCurrentNoteMock: DetailNoteModel.GetNote.Response?
    var presentModifierNoteMock: DetailNoteModel.UpdateNote.Response?

    var fetchPresentCurrentNoteResponce: (() -> Void)?
    var fetchPresentModifierCurrentNoteResponce: (() -> Void)?

    func presentCurrentNote(response: DetailNoteModel.GetNote.Response) {
        presentCurrentNoteWasCalled = true
        presentCurrentNoteMock = response
        fetchPresentCurrentNoteResponce?()
    }

    func presentModifierCurrentNote(response: DetailNoteModel.UpdateNote.Response) {
        presentModifierCurrentNoteWasCalled = true
        presentModifierNoteMock = response
        fetchPresentModifierCurrentNoteResponce?()
    }
}
