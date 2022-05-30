//
//  Router.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 30.05.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func setDetailNote(_ note: Note?, delegate: DetailNotePresenterDelegate?)
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
            guard let mainViewController = assemblyBuilder?.createListNotesModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }

    func setDetailNote(_ note: Note?, delegate: DetailNotePresenterDelegate?) {
        if let navigationController = navigationController {
            guard let detailNoteViewController = assemblyBuilder?.createDetailNoteModule(
                note: note,
                router: self,
                delegate: delegate
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
