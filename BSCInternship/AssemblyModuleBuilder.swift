//
//  AssemblyModuleBuilder.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Builder

import UIKit

protocol AssemblyBuilderProtocol {
    func createListNotesScreen(router: RouterProtocol) -> UIViewController
    func createDetailNoteScreen(
        router: RouterProtocol,
        currentNote: NoteModel?,
        dataStore: ListNotesDataStore?
    ) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Public methods

    func createListNotesScreen(router: RouterProtocol) -> UIViewController {
        let view = ListNotesViewController()
        let interactor = ListNotesInteractor()
        let presenter = ListNotesPresenter()
        view.interactor = interactor
        view.router = router
        interactor.presenter = presenter
        presenter.viewController = view
        return view
    }

    func createDetailNoteScreen(
        router: RouterProtocol,
        currentNote: NoteModel?,
        dataStore: ListNotesDataStore?
    ) -> UIViewController {
        let view = DetailNoteViewController()
        let interactor = DetailNoteInteractor()
        let presenter = DetailNotePresenter()
        view.interactor = interactor
        view.router = router
        interactor.currentNote = currentNote
        interactor.presenter = presenter
        interactor.dataStore = dataStore
        presenter.viewController = view
        return view
    }
}
