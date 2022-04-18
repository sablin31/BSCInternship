//
//  NoteViewController+Extension.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 18.04.2022.
//

import UIKit

extension NoteViewController: ListViewControllerDelegate {
    // MARK: - Delegate methods

    func setCurrentModel(_ model: [Note]) {
        self.model = model
    }

    func getUpdateModel() -> [Note] {
        return self.model
    }
}
