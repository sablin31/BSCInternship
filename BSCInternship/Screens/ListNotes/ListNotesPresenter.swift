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
    func presentAllSaveNotice(response: ListNotesModel.SaveAllNotice.Response)
    func presentNotesAfterDelete(response: ListNotesModel.DeleteNotes.Response)
}

final class ListNotesPresenter: ListNotesPresentationLogic {
    // MARK: - Public proterties

    weak var viewController: ListNotesDisplayLogic?
    // MARK: - Public methods

    func presentNotesInStorage(response: ListNotesModel.GetNotesInStorage.Response) {
        var notesViewModel = NotesViewModel()

        notesViewModel.notesInDevice = response.notesInDevice
        notesViewModel.notesInWeb = noteResponceMoArrayToNoteModelArray(response.notesInWeb)
        let viewModel = ListNotesModel.GetNotesInStorage.ViewModel(notesViewModel: notesViewModel)
        viewController?.showNotesInStorage(viewModel: viewModel)
    }

    func presentNotesInWeb(response: ListNotesModel.GetNotesInWeb.Response) {
        var notesViewModel = NotesViewModel()

        notesViewModel.notesInDevice = response.notesInDevice
        notesViewModel.notesInWeb = noteResponceMoArrayToNoteModelArray(response.notesInWeb)
        let viewModel = ListNotesModel.GetNotesInWeb.ViewModel(notesViewModel: notesViewModel)
        viewController?.showNotesInWeb(viewModel: viewModel)
    }

    func presentNotesAfterDelete(response: ListNotesModel.DeleteNotes.Response) {
        var notesViewModel = NotesViewModel()

        notesViewModel.notesInDevice = response.notesInDevice
        notesViewModel.notesInWeb = noteResponceMoArrayToNoteModelArray(response.notesInWeb)
        let viewModel = ListNotesModel.DeleteNotes.ViewModel(notesViewModel: notesViewModel)
        viewController?.showAllNotesAfterDelete(viewModel: viewModel)
    }

    func presentAllNotice(response: ListNotesModel.GetModel.Response) {
        var notesViewModel = NotesViewModel()

        notesViewModel.notesInDevice = response.notesInDevice
        notesViewModel.notesInWeb = noteResponceMoArrayToNoteModelArray(response.notesInWeb)
        let viewModel = ListNotesModel.GetModel.ViewModel(notesViewModel: notesViewModel)
        viewController?.showAllNotice(viewModel: viewModel)
    }

    func presentAllSaveNotice(response: ListNotesModel.SaveAllNotice.Response) {
        let viewModel = ListNotesModel.SaveAllNotice.ViewModel()
        viewController?.showAllNotesAfterSave(viewModel: viewModel)
    }
}

extension ListNotesPresenter {
    func noteResponceMoArrayToNoteModelArray(_ responceMo: [NoteResponceMo]) -> [NoteModel] {
        var arrayNoteModel = [NoteModel]()
        for item in responceMo {
            let note = NoteModel(
                title: item.title,
                text: item.text,
                userShareIcon: item.userShareIcon,
                id: item.id,
                date: item.date
            )
            arrayNoteModel.append(note)
        }
        return arrayNoteModel
    }
}
