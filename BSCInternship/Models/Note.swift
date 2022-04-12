//
//  Note.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.03.2022.
//

import Foundation

// MARK: - Protocol models

protocol NoteDelegate: AnyObject {
    func updateData(data: NoteProtocol)
}
// MARK: - Protocol delegate

protocol NoteProtocol: NoteDelegate {
    // MARK: Public Properties

    var title: String? { get set }
    var text: String? { get set }
    var date: Date { get set }
}
// MARK: - Object model

class Note: NoteProtocol, NoteDelegate {
    // MARK: Public Properties

    var title: String?
    var text: String?
    var date: Date

    // MARK: Init

    init() {
        date = Date()
    }

    // MARK: Delegate method

    func updateData(data: NoteProtocol) {
        title = data.title
        text = data.text
        date = data.date
    }
}
