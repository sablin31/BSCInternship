//
//  DetailNoteInteractor.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Interactor

import Foundation

protocol DetailNoteBusinessLogic: AnyObject {
    func getCurrentNote(request: DetailNoteModel.GetNote.Request)
    func updateModel(request: DetailNoteModel.UpdateNote.Request)
}

class DetailNoteInteractor: DetailNoteBusinessLogic {
    // MARK: - Public proterties

    var currentNote: NoteModel?
    var presenter: DetailNotePresentationLogic?
    weak var dataStore: ListNotesDataStore?

    func getCurrentNote(request: DetailNoteModel.GetNote.Request) {
        let response = DetailNoteModel.GetNote.Response(currentNote: currentNote)
        self.presenter?.presentCurrentNote(response: response)
    }

    func updateModel(request: DetailNoteModel.UpdateNote.Request) {
        if currentNote != nil {
            currentNote?.title = request.title
            currentNote?.text = request.text
            currentNote?.date = Date()
        } else {
            currentNote = NoteModel(title: request.title, text: request.text, userShareIcon: nil)
        }
        if let currentNote = currentNote {
            if let item = dataStore?.notesInWeb.firstIndex( where: { $0.id == currentNote.id }) {
                dataStore?.notesInWeb[item].title = currentNote.title
                dataStore?.notesInWeb[item].text = currentNote.text
                dataStore?.notesInWeb[item].date = Date()
            } else {
                if let item = dataStore?.notesInDevice.firstIndex( where: { $0.id == currentNote.id }) {
                    dataStore?.notesInDevice[item].title = currentNote.title
                    dataStore?.notesInDevice[item].text = currentNote.text
                    dataStore?.notesInDevice[item].date = Date()
                } else { dataStore?.notesInDevice.append(currentNote) }
            }
        }
        let response = DetailNoteModel.UpdateNote.Response(currentNote: currentNote)
        self.presenter?.presentModifierCurrentNote(response: response)
    }
}
