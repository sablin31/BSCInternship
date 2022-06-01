//
//  NotesModel.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.05.2022.
//

import Foundation

struct NotesModel {
    // MARK: - Public Properties

    var notesInDevice: [Note]
    var notesInWeb: [Note]
    // MARK: - Init

    init(
        notesInDevice: [Note] = [],
        notesInWeb: [Note] = []
    ) {
        self.notesInDevice = notesInDevice
        self.notesInWeb = notesInWeb
    }
}
