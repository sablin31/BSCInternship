//
//  NoteResponceMo.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 06.06.2022.
//

import Foundation

struct NoteResponceMo: Codable, Identifiable, Equatable {
    // MARK: - Public Properties

    var id: UUID
    var title: String?
    var text: String?
    var date: Date
    var userShareIcon: String?
    // MARK: - Init

    init(
        title: String?,
        text: String?,
        userShareIcon: String?,
        id: UUID = UUID(),
        date: Date = Date()
    ) {
        self.title = title
        self.text = text
        self.userShareIcon = userShareIcon
        self.id = id
        self.date = date
    }
}
