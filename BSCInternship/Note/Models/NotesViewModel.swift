//
//  NotesModel.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//

import Foundation

struct NotesViewModel {
    // MARK: - Public Properties

    var notesInDevice: [NoteModel]
    var notesInWeb: [NoteModel]
    // MARK: - Init

    init(
        notesInDevice: [NoteModel] = [],
        notesInWeb: [NoteModel] = []
    ) {
        self.notesInDevice = notesInDevice
        self.notesInWeb = notesInWeb
    }
}
