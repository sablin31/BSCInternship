//
//  Note.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.03.2022.
//

import Foundation

// MARK: - Struct model

struct Note: Codable, Identifiable {
    // MARK: - Public Properties

    var id = UUID()
    var title: String?
    var text: String?
    var date: Date

    // MARK: - Init

    init(
        title: String?,
        text: String?,
        date: Date = Date()
    ) {
        self.title = title
        self.text = text
        self.date = date
    }
}
