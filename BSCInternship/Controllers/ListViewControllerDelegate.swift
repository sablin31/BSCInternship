//
//  ListViewControllerDelegate.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 19.04.2022.
//

import UIKit

// MARK: - Protocol delegate

protocol ListViewControllerDelegate: AnyObject {
    func setCurrentModel(_ model: [Note])
    func getUpdateModel() -> [Note]
}
