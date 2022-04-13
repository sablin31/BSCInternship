//
//  Note.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.03.2022.
//

import Foundation

// MARK: - Protocol model

protocol NoteProtocol: Decodable {
    // MARK: - Public Properties

    var title: String? { get set }
    var text: String? { get set }
    var date: Date { get set }
}
// MARK: - Struct model

class Note: NoteProtocol, Codable {
    // MARK: - Public Properties

    var title: String?
    var text: String?
    var date: Date

    // MARK: - Init
    init(title: String?, text: String?) {
        self.title = title
        self.text = text
        self.date = Date()
    }
}
