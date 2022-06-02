//
//  ListNotesModels.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
//  Models

import Foundation
// VIP cycles
enum ListNotesModel {
    // MARK: Get notes in storage
    enum GetNotesInStorage {
        // ViewController to Interactor
        struct Request {
            var keyDataSource: String
        }
        // Interactor to Presenter
        struct Response {
            let notesModel: NotesModel
        }
        // Presentor to ViewController
        struct ViewModel {
            let notesModel: NotesModel
        }
    }

    // MARK: Get notes in Web
    enum GetNotesInWeb {
        // ViewController to Interactor
        struct Request {
            var url: URL?
        }
        // Interactor to Presenter
        struct Response {
            let notesModel: NotesModel
        }
        // Presentor to ViewController
        struct ViewModel {
            let notesModel: NotesModel
        }
    }

    // MARK: Delete notes
    enum DeleteNotes {
        // ViewController to Interactor
        struct Request {
            var selectedRows: [IndexPath]
        }
        // Interactor to Presenter
        struct Response {
            let notesModel: NotesModel
        }
        // Presentor to ViewController
        struct ViewModel {
            let notesModel: NotesModel
        }
    }

    // MARK: Get all notes
    enum GetModel {
        // ViewController to Interactor
        struct Request {}
        // Interactor to Presenter
        struct Response {
            let notesModel: NotesModel
        }
        // Presentor to ViewController
        struct ViewModel {
            let notesModel: NotesModel
        }
    }

    // MARK: Save notes after close app
    enum SaveAllNotice {
        // ViewController to Interactor
        struct Request {
            var keyDataSource: String
        }
        // Interactor to Presenter
        struct Response {}
        // Presentor to ViewController
        struct ViewModel {}
    }
}
