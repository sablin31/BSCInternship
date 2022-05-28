//
//  ModuleBuilder.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 28.05.2022.
//

import UIKit

protocol Builder {
    static func createListNotesModule() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createListNotesModule() -> UIViewController {
        let view = ListNotesViewController()
        let workerWeb = WorkerWeb()
        let workerStorage = WorkerStorage()
        let presenter = ListNotesPresenter(view: view, workerWeb: workerWeb, workerStorage: workerStorage)
        view.presenter = presenter
        return view
    }
}
