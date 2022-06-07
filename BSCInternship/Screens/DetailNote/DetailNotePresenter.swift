//
//  DetailNotePresenter.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Presenter

import Foundation
import UIKit

protocol DetailNotePresentationLogic: AnyObject {
    func presentCurrentNote(response: DetailNoteModel.GetNote.Response)
    func presentModifierCurrentNote(response: DetailNoteModel.UpdateNote.Response)
}

class DetailNotePresenter: DetailNotePresentationLogic {
    // MARK: - Public proterties
    var formattedCurrentNote: NoteModel?

    weak var viewController: DetailNoteDisplayLogic?
    // MARK: - Public methods

    func presentCurrentNote(response: DetailNoteModel.GetNote.Response) {
        let viewModel = DetailNoteModel.GetNote.ViewModel(
            title: response.currentNote?.title,
            text: response.currentNote?.text,
            date: response.currentNote?.date.toString(dateFormat: Constants.dateFormat) ??
            Date().toString(dateFormat: Constants.dateFormat)
        )
        viewController?.showNote(viewModel: viewModel)
    }

    func presentModifierCurrentNote(response: DetailNoteModel.UpdateNote.Response) {
        let viewModel = DetailNoteModel.GetNote.ViewModel(
            title: response.currentNote?.title,
            text: response.currentNote?.text,
            date: response.currentNote?.date.toString(dateFormat: Constants.dateFormat) ??
            Date().toString(dateFormat: Constants.dateFormat)
        )
        viewController?.showNote(viewModel: viewModel)
    }
}

// MARK: - Constants

extension DetailNotePresenter {
    private enum Constants {
        static let dateFormat = "dd.MM.yyyy EEEE HH:mm"
    }
}
