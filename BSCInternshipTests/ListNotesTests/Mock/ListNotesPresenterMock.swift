//
//  ListNotesPresenterMock.swift
//  BSCInternshipTests
//
//  Created by Алексей Саблин on 08.06.2022.
//

import Foundation
@testable import BSCInternship

final class ListNotesPresenterMock: ListNotesPresentationLogic {
    var viewController: ListNotesDisplayLogic?

    var presentNotesInStorageWasCalled = false
    var presentAllNotesWasCalled = false
    var presentAllSaveNotesWasCalled = false
    var presentNotesAfterDeleteWasCalled = false

    var presentNotesInStorageMock: ListNotesModel.GetNotesInStorage.Response?
    var presentAllNotesMock: ListNotesModel.GetModel.Response?
    var presentAllSaveNotesMock: ListNotesModel.SaveAllNotice.Response?
    var presentNotesAfterDeleteMock: ListNotesModel.DeleteNotes.Response?

    var fetchPresentNotesInStorageResponce: (() -> Void)?
    var fetchPresentAllNotesResponce: (() -> Void)?
    var fetchPresentAllSaveNotesResponce: (() -> Void)?
    var fetchPresentNotesAfterDeleteResponce: (() -> Void)?

    func presentNotesInStorage(response: ListNotesModel.GetNotesInStorage.Response) {
        presentNotesInStorageWasCalled = true
        presentNotesInStorageMock = response
        fetchPresentNotesInStorageResponce?()
    }

    func presentNotesInWeb(response: ListNotesModel.GetNotesInWeb.Response) {}

    func presentAllNotes(response: ListNotesModel.GetModel.Response) {
        presentAllNotesWasCalled = true
        presentAllNotesMock = response
        fetchPresentAllNotesResponce?()
    }

    func presentAllSaveNotes(response: ListNotesModel.SaveAllNotice.Response) {
        presentAllSaveNotesWasCalled = true
        presentAllSaveNotesMock = response
        fetchPresentAllSaveNotesResponce?()
    }

    func presentNotesAfterDelete(response: ListNotesModel.DeleteNotes.Response) {
        presentNotesAfterDeleteWasCalled = true
        presentNotesAfterDeleteMock = response
        fetchPresentNotesAfterDeleteResponce?()
    }
}
