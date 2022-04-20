//
//  ListViewController+Extension.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 19.04.2022.
//

import UIKit

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Delegate methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ConstantsTableView.heightForRowAt
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConstantsTableView.cellIdentifier
        ) as? NoteCell else {
            fatalError(ConstantsTableView.errorCreateCell)
        }
        let note = notes[indexPath.row]
        cell.set(with: note)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentNoteViewControler = NoteViewController()
        delegate = currentNoteViewControler
        currentNoteViewControler.currentNote = notes[indexPath.row]
        delegate?.setCurrentModel(notes)
        self.navigationController?.pushViewController(currentNoteViewControler, animated: true)
    }
}
// MARK: - Constants

extension ListViewController {
    enum ConstantsTableView {
        // MARK: String constants

        static let cellIdentifier = "noteCell"
        static let errorCreateCell = "Not found this type cell"

        // MARK: UI properties cells

        static let heightForRowAt = 94.0
    }
}
