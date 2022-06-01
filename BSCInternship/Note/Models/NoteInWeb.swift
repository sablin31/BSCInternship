//
//  Note.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 16.05.2022.
//
//  Note in Web

import Foundation

struct NoteInWeb: Decodable {
    // MARK: - Public Properties

    let title: String?
    let text: String?
    let userShareIcon: String?
    let date: Int64?
    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case title = "header"
        case text
        case userShareIcon
        case date
    }
    // MARK: - Init

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try? container.decode(String.self, forKey: .title)
        self.text = try? container.decode(String.self, forKey: .text)
        self.userShareIcon = try? container.decode(String.self, forKey: .userShareIcon)
        self.date = try? container.decode(Int64.self, forKey: .date)
    }
}
