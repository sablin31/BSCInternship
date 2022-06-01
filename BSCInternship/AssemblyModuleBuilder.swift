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
        currentNote: Note?,
        delegate: DetailNoteInteractorDelegate?
    ) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Public methods

    func createListNotesScreen(router: RouterProtocol) -> UIViewController {
        let view = ListNotesViewController()
        let interactor = ListNotesInteractor()
        let presenter = ListNotesPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        interactor.router = router
        presenter.viewController = view
        return view
    }

    func createDetailNoteScreen(
        router: RouterProtocol,
        currentNote: Note?,
        delegate: DetailNoteInteractorDelegate?
    ) -> UIViewController {
        let view = DetailNoteViewController()
        let interactor = DetailNoteInteractor()
        let presenter = DetailNotePresenter()
        view.interactor = interactor
        interactor.currentNote = currentNote
        interactor.presenter = presenter
        interactor.router = router
        interactor.delegate = delegate
        presenter.viewController = view
        return view
    }
}
