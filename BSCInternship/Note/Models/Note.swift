//
//  Note.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.03.2022.
//
//  Note in device mode

import Foundation

struct Note: Codable, Identifiable, Equatable {
    // MARK: - Public Properties

    var id = UUID()
    var title: String?
    var text: String?
    var date: Date
    var userShareIcon: String?
    // MARK: - Init

    init(
        title: String?,
        text: String?,
        userShareIcon: String?,
        date: Date = Date()
    ) {
        self.title = title
        self.text = text
        self.date = date
        self.userShareIcon = userShareIcon
    }
}