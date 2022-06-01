//
//  ListNotesPresenter.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Presenter

import Foundation

protocol ListNotesPresentationLogic: AnyObject {
    func presentNotesInStorage(response: ListNotesModel.GetNotesInStorage.Response)
    func presentNotesInWeb(response: ListNotesModel.GetNotesInWeb.Response)
    func presentAllNotice(response: ListNotesModel.GetModel.Response)
    func presentNotesAfterDelete(response: ListNotesModel.DeleteNotes.Response)
}

final class ListNotesPresenter: ListNotesPresentationLogic {
    // MARK: - Public proterties
    var notesModel = NotesModel()

    weak var viewController: ListNotesDisplayLogic?
    // MARK: - Public methods

    func presentNotesInStorage(response: ListNotesModel.GetNotesInStorage.Response) {
        notesModel = response.notesModel

        let viewModel = ListNotesModel.GetNotesInStorage.ViewModel(notesModel: notesModel)
        viewController?.getNotesInStorage(viewModel: viewModel)
    }

    func presentNotesInWeb(response: ListNotesModel.GetNotesInWeb.Response) {
        notesModel = response.notesModel

        let viewModel = ListNotesModel.GetNotesInWeb.ViewModel(notesModel: notesModel)
        viewController?.getNotesInWeb(viewModel: viewModel)
    }

    func presentNotesAfterDelete(response: ListNotesModel.DeleteNotes.Response) {
        notesModel = response.notesModel

        let viewModel = ListNotesModel.DeleteNotes.ViewModel(notesModel: notesModel)
        viewController?.getAllNotesAfterDelete(viewModel: viewModel)
    }

    func presentAllNotice(response: ListNotesModel.GetModel.Response) {
        notesModel = response.notesModel

        let viewModel = ListNotesModel.GetModel.ViewModel(notesModel: notesModel)
        viewController?.getAllNotice(viewModel: viewModel)
    }
}