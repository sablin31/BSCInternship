//
//  DetailNoteModel.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//
import Foundation
// VIP cycles
enum DetailNoteModel {
    // MARK: Show
    enum GetNote {
        // ViewController to Interactor
        struct Request {}
        // Interactor to Presenter
        struct Response {
            let currentNote: NoteModel?
        }
        // Presentor to ViewController
        struct ViewModel {
            let title: String?
            let text: String?
            let date: String
        }
    }
    // MARK: UpdateNote
    enum UpdateNote {
        // ViewController to Interactor
        struct Request {
            let title: String?
            let text: String?
        }
        // Interactor to Presenter
        struct Response {
            let currentNote: NoteModel?
        }
        // Presentor to ViewController
        struct ViewModel {
            let title: String?
            let text: String?
            let date: String
        }
    }
}
