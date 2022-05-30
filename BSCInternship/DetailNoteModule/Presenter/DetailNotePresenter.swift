//
//  DetailNotePresenter.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 30.05.2022.
//

import Foundation

// MARK: - DetailNoteView protocol

protocol DetailNoteViewProtocol: AnyObject {}
// MARK: - DetailNotePresenter protocol

protocol DetailNotePresenterProtocol: AnyObject {
    var note: Note? { get set }

    init(view: DetailNoteViewProtocol, router: RouterProtocol, with note: Note?, delegate: DetailNotePresenterDelegate?)

    func returnToListNotes()
    func updateNote(title: String?, text: String?)
}
// MARK: - DetailNotePresenterDelegate protocol

protocol DetailNotePresenterDelegate: AnyObject {
    func noteWasChanged(with note: Note)
}
// MARK: - DetailNoteModule presenter

class DetailNotePresenter: DetailNotePresenterProtocol {
    // MARK: - Public properties

    weak var view: DetailNoteViewProtocol?
    weak var delegate: DetailNotePresenterDelegate?

    var router: RouterProtocol?
    var note: Note?
    // MARK: - Init

    required init(
        view: DetailNoteViewProtocol,
        router: RouterProtocol,
        with note: Note?,
        delegate: DetailNotePresenterDelegate?
    ) {
        self.view = view
        self.router = router
        self.note = note
        self.delegate = delegate
    }

    func returnToListNotes() {
        router?.popToRoot()
    }

    func updateNote(title: String?, text: String?) {
        if note != nil {
            note?.title = title
            note?.text = text
            note?.date = Date()
        } else {
            note = Note(title: title, text: text, userShareIcon: nil)
        }
        if let note = note {
            delegate?.noteWasChanged(with: note)
        }
    }
}
