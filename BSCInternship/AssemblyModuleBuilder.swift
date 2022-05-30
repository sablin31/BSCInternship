//
//  AssemblyModuleBuilder.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 28.05.2022.
//

import UIKit

// MARK: - Builder protocol

protocol AssemblyBuilderProtocol {
    func createListNotesModule(router: RouterProtocol) -> UIViewController
    func createDetailNoteModule(
        note: Note?,
        router: RouterProtocol,
        delegate: DetailNotePresenterDelegate?
    ) -> UIViewController
}
// MARK: - Module builder

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Public methods

    func createListNotesModule(router: RouterProtocol) -> UIViewController {
        let view = ListNotesViewController()
        let workerWeb = WorkerWeb()
        let workerStorage = WorkerStorage()
        let presenter = ListNotesPresenter(
            view: view,
            workerWeb: workerWeb,
            workerStorage: workerStorage,
            router: router
        )
        view.presenter = presenter
        return view
    }

    func createDetailNoteModule(
        note: Note?,
        router: RouterProtocol,
        delegate: DetailNotePresenterDelegate?
    ) -> UIViewController {
        let view = DetailNoteViewController()
        let presenter = DetailNotePresenter(
            view: view,
            router: router,
            with: note,
            delegate: delegate
        )
        view.presenter = presenter
        return view
    }
}
