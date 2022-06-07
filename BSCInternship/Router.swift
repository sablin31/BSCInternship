//
//  Router.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func routeToDetailNoteController(with note: NoteModel?, dataStore: ListNotesDataStore?)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createListNotesScreen(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }

    func routeToDetailNoteController(with note: NoteModel?, dataStore: ListNotesDataStore?) {
        if let navigationController = navigationController {
            guard let detailNoteViewController = assemblyBuilder?.createDetailNoteScreen(
                router: self,
                currentNote: note,
                dataStore: dataStore
            ) else { return }
            navigationController.pushViewController(detailNoteViewController, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
