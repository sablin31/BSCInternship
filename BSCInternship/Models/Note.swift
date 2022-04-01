//
//  Note.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 31.03.2022.
//

import Foundation
// MARK: - Protocol model
protocol NoteProtocol {
    var title: String? { get set }

    var text: String? { get set }

    var date: Date { get set }

    var isEmpty: Bool { get }
}
// MARK: - Struct model
struct Note: NoteProtocol, Codable {
    var title: String?

    var text: String?

    var date: Date

    var isEmpty: Bool {
        return title == nil && text == nil ? true : false
    }
}
