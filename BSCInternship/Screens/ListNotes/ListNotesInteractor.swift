//
//  ListNotesInteractor.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Interactor

import Foundation

protocol ListNotesBusinessLogic: AnyObject {
    var presenter: ListNotesPresentationLogic? { get set }
    var workerStorage: DataSourceServiceProtocol? { get set }
    var workerWeb: NetworkServiceProtocol? { get set }

    func getNotesInStorage(request: ListNotesModel.GetNotesInStorage.Request)
    func getNotesInWeb(request: ListNotesModel.GetNotesInWeb.Request)
    func updateModel(request: ListNotesModel.GetModel.Request)
    func saveAllNotes(request: ListNotesModel.SaveAllNotice.Request)
    func deleteNotes(request: ListNotesModel.DeleteNotes.Request)
}

protocol ListNotesDataStore: AnyObject {
    var notesInDevice: [NoteModel] { get set }
    var notesInWeb: [NoteResponceMo] { get set }
}

final class ListNotesInteractor: ListNotesBusinessLogic, ListNotesDataStore {
    // MARK: - Public properties

    var notesInDevice = [NoteModel]()
    var notesInWeb = [NoteResponceMo]()
    var presenter: ListNotesPresentationLogic?
    var workerStorage: DataSourceServiceProtocol?
    var workerWeb: NetworkServiceProtocol?
    // MARK: - Public methods

    func getNotesInStorage(request: ListNotesModel.GetNotesInStorage.Request) {
        notesInDevice = workerStorage?.loadDate(key: request.keyDataSource) ?? []
        let response = ListNotesModel.GetNotesInStorage.Response(
            notesInDevice: notesInDevice,
            notesInWeb: notesInWeb
        )
        self.presenter?.presentNotesInStorage(response: response)
    }

    func getNotesInWeb(request: ListNotesModel.GetNotesInWeb.Request) {
        workerWeb?.fetch(url: request.url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                switch result {
                case .success(let notes):
                    if let notes = notes {
                        for note in notes {
                            let newNote = NoteResponceMo(
                                title: note.title,
                                text: note.text,
                                userShareIcon: note.userShareIcon,
                                date: Date(
                                    timeIntervalSince1970: TimeInterval(
                                        note.date ?? Int64(Date().timeIntervalSince1970)
                                    )
                                )
                            )
                            self.notesInWeb.append(newNote)
                            let response = ListNotesModel.GetNotesInWeb.Response(
                                notesInDevice: self.notesInDevice,
                                notesInWeb: self.notesInWeb
                            )
                            self.presenter?.presentNotesInWeb(response: response)
                        }
                    }
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }

    func updateModel(request: ListNotesModel.GetModel.Request) {
        let response = ListNotesModel.GetModel.Response(
            notesInDevice: notesInDevice,
            notesInWeb: notesInWeb
        )
        self.presenter?.presentAllNotes(response: response)
    }

    func saveAllNotes(request: ListNotesModel.SaveAllNotice.Request) {
        workerStorage?.save(notes: self.notesInDevice, key: request.keyDataSource)
        let response = ListNotesModel.SaveAllNotice.Response()
        self.presenter?.presentAllSaveNotes(response: response)
    }

    func deleteNotes(request: ListNotesModel.DeleteNotes.Request) {
        var deleteNotesInDevice = [NoteModel]()
        var deleteNotesInWeb = [NoteResponceMo]()
        for indexPath in request.selectedRows {
            if indexPath.section == Constants.notesInDeviceNumberOfSection {
                deleteNotesInDevice.append(notesInDevice[indexPath.row])
            }
            if indexPath.section == Constants.notesInWebNumberOfSection {
                deleteNotesInWeb.append(notesInWeb[indexPath.row])
            }
        }
        for deleteNoteInDevice in deleteNotesInDevice {
            if let index = notesInDevice.firstIndex(of: deleteNoteInDevice) {
                notesInDevice.remove(at: index)
            }
        }
        for deleteNoteInWeb in deleteNotesInWeb {
            if let index = notesInWeb.firstIndex(of: deleteNoteInWeb) {
                notesInWeb.remove(at: index)
            }
        }

        let response = ListNotesModel.DeleteNotes.Response(
            notesInDevice: notesInDevice,
            notesInWeb: notesInWeb
        )
        self.presenter?.presentNotesAfterDelete(response: response)
    }
}
// MARK: - Constants

extension ListNotesInteractor {
    private enum Constants {
        static let notesInDeviceNumberOfSection = 0
        static let notesInWebNumberOfSection = 1
    }
}
