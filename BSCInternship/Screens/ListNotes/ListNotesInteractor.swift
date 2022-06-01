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
    func getAllNotice()
    func saveAllNotice(request: ListNotesModel.SaveAllNotice.Request)
    func showDetailNote(request: ListNotesModel.ShowDetailNote.Request)
    func deleteNotes(request: ListNotesModel.DeleteNotes.Request)
}

protocol ListNotesDataStore: AnyObject {
    var notesModel: NotesModel { get set }
}

final class ListNotesInteractor: ListNotesBusinessLogic, ListNotesDataStore {
    // MARK: - Public properties

    var notesModel = NotesModel()
    var presenter: ListNotesPresentationLogic?
    var router: RouterProtocol?
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

    func getAllNotice() {
        let response = ListNotesModel.GetModel.Response(notesModel: notesModel)
        self.presenter?.presentAllNotice(response: response)
    }

    func saveAllNotice(request: ListNotesModel.SaveAllNotice.Request) {
        workerStorage.save(notes: self.notesModel.notesInDevice, key: request.keyDataSource)
    }

    func showDetailNote(request: ListNotesModel.ShowDetailNote.Request) {
        router?.routeToDetailNoteController(with: request.currentNote, delegate: self)
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
// MARK: - DetailNoteInteractorDelegate

extension ListNotesInteractor: DetailNoteInteractorDelegate {
    func noteWasChanged(with note: Note) {
        if let item = self.notesModel.notesInWeb.firstIndex( where: { $0.id == note.id }) {
            self.notesModel.notesInWeb[item].title = note.title
            self.notesModel.notesInWeb[item].text = note.text
            self.notesModel.notesInWeb[item].date = Date()
        } else {
            if let item = self.notesModel.notesInDevice.firstIndex( where: { $0.id == note.id }) {
                self.notesModel.notesInDevice[item].title = note.title
                self.notesModel.notesInDevice[item].text = note.text
                self.notesModel.notesInDevice[item].date = Date()
            } else { self.notesModel.notesInDevice.append(note) }
        }
    }
}
// MARK: - Constants

extension ListNotesInteractor {
    private enum Constants {
        static let notesInDeviceNumberOfSection = 0
        static let notesInWebNumberOfSection = 1
    }
}
