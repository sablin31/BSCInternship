//
//  DetailNoteInteractor.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Interactor

import Foundation

protocol DetailNoteBusinessLogic: AnyObject {
    func getCurrentNote()
    func updateModel(request: DetailNoteModel.UpdateNote.Request)
    func comeBackToListNotes()
}

protocol DetailNoteDataStore: AnyObject {
    var currentNote: Note? { get set }
}

protocol DetailNoteInteractorDelegate: AnyObject {
    func noteWasChanged(with note: Note)
}

class DetailNoteInteractor: DetailNoteBusinessLogic, DetailNoteDataStore {
    // MARK: - Public proterties

    var currentNote: Note?
    var presenter: DetailNotePresentationLogic?
    weak var delegate: DetailNoteInteractorDelegate?
    var router: RouterProtocol?

    func getCurrentNote() {
        let response = DetailNoteModel.GetNote.Response(currentNote: currentNote)
        self.presenter?.presentCurrentNote(response: response)
    }

    func updateModel(request: DetailNoteModel.UpdateNote.Request) {
        if currentNote != nil {
            currentNote?.title = request.title
            currentNote?.text = request.text
            currentNote?.date = Date()
        } else {
            currentNote = Note(title: request.title, text: request.text, userShareIcon: nil)
        }
        if let currentNote = currentNote {
            delegate?.noteWasChanged(with: currentNote)
        }
        let response = DetailNoteModel.UpdateNote.Response(currentNote: currentNote)
        self.presenter?.presentModifierCurrentNote(response: response)
    }

    func comeBackToListNotes() {
        router?.popToRoot()
    }
}
