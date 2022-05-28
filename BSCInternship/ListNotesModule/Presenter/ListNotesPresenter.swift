//
//  ListNotesPresenter.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 28.05.2022.
//

import Foundation

protocol ListNotesViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol ListNotesViewPresenterProtocol: AnyObject {
    init(view: ListNotesViewProtocol, workerWeb: WorkerWeb, workerStorage: WorkerStorage)
    var notesInDevice: [Note] { get set }
    var notesInWeb: [Note] { get set }
}

class ListNotesPresenter: ListNotesViewPresenterProtocol {
    weak var view: ListNotesViewProtocol?
    let workerWeb: WorkerWeb
    let workerStorage: WorkerStorage
    var notesInDevice: [Note] = []
    var notesInWeb: [Note] = []

    required init(view: ListNotesViewProtocol, workerWeb: WorkerWeb, workerStorage: WorkerStorage) {
        self.view = view
        self.workerWeb = workerWeb
        self.workerStorage = workerStorage
        getNotes()
    }
    func getNotes() {
        notesInDevice = workerStorage.loadDate(key: Constants.dataStorageKey) ?? []
        workerWeb.fetch { [weak self] notes in
            guard let notes = notes else { return }
            if notes.isEmpty == false {
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
                    self?.notesInWeb.append(newNote)
                }
                self?.spinner.removeFromSuperview()
                self?.tableView.reloadData()
            }
        }
    }
}
