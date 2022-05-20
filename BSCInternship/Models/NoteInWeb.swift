//
//  Note.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 16.05.2022.
//

import Foundation

// MARK: - Note in web model

struct NoteInWeb: Decodable {
    // MARK: - Public Properties

    let title: String?
    let text: String?
    let date: Int64?
    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case title = "header"
        case text
        case date
    }
}
