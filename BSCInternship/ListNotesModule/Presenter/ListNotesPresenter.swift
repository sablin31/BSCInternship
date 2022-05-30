//
//  ListNotesPresenter.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 28.05.2022.
//

import Foundation
import UIKit

// MARK: - ListNotesView protocol

protocol ListNotesViewProtocol: AnyObject {
    func reloadData()
    func successWeb()
    func failureWeb(error: Error)
}
// MARK: - ListNotesPresenter protocol

protocol ListNotesPresenterProtocol: AnyObject {
    var notesInDevice: [Note] { get set }
    var notesInWeb: [Note] { get set }

    init(view: ListNotesViewProtocol, workerWeb: WorkerWeb, workerStorage: WorkerStorage, router: RouterProtocol)

    func showDetailNote(_ note: Note?)
    func readNotes()
    func deleteNotes(at selectedRows: [IndexPath])
    func deleteNotes(at selectedRow: IndexPath)
    func saveNotes()
}
// MARK: - ListNotesModule presenter

final class ListNotesPresenter: ListNotesPresenterProtocol {
    // MARK: - Public properties

    weak var view: ListNotesViewProtocol?
    var router: RouterProtocol?
    var notesInDevice: [Note] = []
    var notesInWeb: [Note] = []
    // MARK: - Private properties

    private let workerStorage: WorkerStorage
    private let workerWeb: WorkerWeb
    // MARK: - Init

    required init(
        view: ListNotesViewProtocol,
        workerWeb: WorkerWeb,
        workerStorage: WorkerStorage,
        router: RouterProtocol
    ) {
        self.view = view
        self.workerWeb = workerWeb
        self.workerStorage = workerStorage
        self.router = router
    }
    // MARK: - Public methods

    func showDetailNote(_ note: Note?) {
        router?.setDetailNote(note, delegate: self)
    }

    func readNotes() {
        notesInDevice = workerStorage.loadNotes() ?? []
        workerWeb.getNotes { [weak self] result in
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
                            self.notesInWeb.append(newNote)
                            self.view?.successWeb()
                        }
                    }
                case .failure(let error):
                    self.view?.failureWeb(error: error)
                }
            }
        }
    }

    func deleteNotes(at selectedRows: [IndexPath]) {
        var deleteNotes = [Note]()
        for indexPath in selectedRows {
            if indexPath.section == Constants.notesInDeviceNumberOfSection {
                deleteNotes.append(notesInDevice[indexPath.row])
            }
            if indexPath.section == Constants.notesInWebNumberOfSection {
                deleteNotes.append(notesInWeb[indexPath.row])
            }
        }
        for deleteNote in deleteNotes {
            if let index = notesInDevice.firstIndex(of: deleteNote) {
                notesInDevice.remove(at: index)
            }
            if let index = notesInWeb.firstIndex(of: deleteNote) {
                notesInWeb.remove(at: index)
            }
        }
    }

    func deleteNotes(at indexPath: IndexPath) {
        if indexPath.section == Constants.notesInDeviceNumberOfSection {
            notesInDevice.remove(at: indexPath.row)
        }
        if indexPath.section == Constants.notesInWebNumberOfSection {
            notesInWeb.remove(at: indexPath.row)
        }
        view?.reloadData()
    }

    func saveNotes() {
        if notesInDevice.isEmpty == false {
            workerStorage.saveNotes(notes: notesInDevice)
        }
    }
}
extension ListNotesPresenter: DetailNotePresenterDelegate {
    func noteWasChanged(with note: Note) {
        if let item = self.notesInDevice.firstIndex( where: { $0.id == note.id }) {
            self.notesInDevice[item].title = note.title
            self.notesInDevice[item].text = note.text
            self.notesInDevice[item].date = Date()
        } else {
            if let item = self.notesInWeb.firstIndex( where: { $0.id == note.id }) {
                self.notesInWeb[item].title = note.title
                self.notesInWeb[item].text = note.text
                self.notesInWeb[item].date = Date()
            } else { self.notesInDevice.append(note) }
        }
    }
}
// MARK: - Constants

extension ListNotesPresenter {
    private enum Constants {
        static let notesInDeviceNumberOfSection = 0
        static let notesInWebNumberOfSection = 1
    }
}
