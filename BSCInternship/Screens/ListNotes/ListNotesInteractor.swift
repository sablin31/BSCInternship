//
//  ListNotesInteractor.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Interactor

import Foundation

protocol ListNotesBusinessLogic: AnyObject {
    func getNotesInStorage(request: ListNotesModel.GetNotesInStorage.Request)
    func getNotesInWeb(request: ListNotesModel.GetNotesInWeb.Request)
    func getAllNotice(request: ListNotesModel.GetModel.Request)
    func saveAllNotice(request: ListNotesModel.SaveAllNotice.Request)
    func deleteNotes(request: ListNotesModel.DeleteNotes.Request)
}

protocol ListNotesDataStore: AnyObject {
    var notesModel: NotesModel { get set }
}

final class ListNotesInteractor: ListNotesBusinessLogic, ListNotesDataStore {
    // MARK: - Public properties

    var notesModel = NotesModel()
    var presenter: ListNotesPresentationLogic?
    // MARK: - Private properties

    private let workerStorage = WorkerStorage()
    private let workerWeb = WorkerWeb()
    // MARK: - Public methods

    func getNotesInStorage(request: ListNotesModel.GetNotesInStorage.Request) {
        notesModel.notesInDevice = workerStorage.loadDate(key: request.keyDataSource) ?? []
        let response = ListNotesModel.GetNotesInStorage.Response(notesModel: notesModel)
        self.presenter?.presentNotesInStorage(response: response)
    }

    func getNotesInWeb(request: ListNotesModel.GetNotesInWeb.Request) {
        workerWeb.fetch(url: request.url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                switch result {
                case .success(let notes):
                    if let notes = notes {
                        for note in notes {
                            let newNote = Note(
                                title: note.title,
                                text: note.text,
                                userShareIcon: note.userShareIcon,
                                date: Date(
                                    timeIntervalSince1970: TimeInterval(
                                        note.date ?? Int64(Date().timeIntervalSince1970)
                                    )
                                )
                            )
                            self.notesModel.notesInWeb.append(newNote)
                            let response = ListNotesModel.GetNotesInWeb.Response(notesModel: self.notesModel)
                            self.presenter?.presentNotesInWeb(response: response)
                        }
                    }
                case .failure(let error):
                    print("Error \(error)")
                }
            }
        }
    }

    func getAllNotice(request: ListNotesModel.GetModel.Request) {
        let response = ListNotesModel.GetModel.Response(notesModel: notesModel)
        self.presenter?.presentAllNotice(response: response)
    }

    func saveAllNotice(request: ListNotesModel.SaveAllNotice.Request) {
        workerStorage.save(notes: self.notesModel.notesInDevice, key: request.keyDataSource)
        let response = ListNotesModel.SaveAllNotice.Response()
        self.presenter?.presentAllSaveNotice(response: response)
    }

    func deleteNotes(request: ListNotesModel.DeleteNotes.Request) {
        var deleteNotesInDevice = [Note]()
        var deleteNotesInWeb = [Note]()
        for indexPath in request.selectedRows {
            if indexPath.section == Constants.notesInDeviceNumberOfSection {
                deleteNotesInDevice.append(notesModel.notesInDevice[indexPath.row])
            }
            if indexPath.section == Constants.notesInWebNumberOfSection {
                deleteNotesInWeb.append(notesModel.notesInWeb[indexPath.row])
            }
        }
        for deleteNoteInDevice in deleteNotesInDevice {
            if let index = notesModel.notesInDevice.firstIndex(of: deleteNoteInDevice) {
                notesModel.notesInDevice.remove(at: index)
            }
        }
        for deleteNoteInWeb in deleteNotesInWeb {
            if let index = notesModel.notesInWeb.firstIndex(of: deleteNoteInWeb) {
                notesModel.notesInWeb.remove(at: index)
            }
        }

        let response = ListNotesModel.DeleteNotes.Response(notesModel: notesModel)
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
