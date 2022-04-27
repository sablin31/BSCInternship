//
//  Date+Extension.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 10.04.2022.
//

import Foundation

// MARK: - Date to String formatted

extension Date {
    func toString(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
