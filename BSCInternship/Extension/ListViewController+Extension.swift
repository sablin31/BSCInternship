//
//  ListViewController+Extension.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 19.04.2022.
//

import UIKit

// MARK: - UITableViewDataSource, UITableViewDelegate methods

extension ListViewController: UITableViewDataSource {
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
}
// MARK: - UITableViewDelegate methods

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentNoteViewControler = NoteViewController()
        currentNoteViewControler.delegate = self
        currentNoteViewControler.currentNote = notes[indexPath.row]
        self.navigationController?.pushViewController(currentNoteViewControler, animated: true)
    }
}
// MARK: - NoteViewControllerDelegate methods

extension ListViewController: NoteViewControllerDelegate {
    func noteWasChanged(with note: Note) {
        if let item = self.notes.firstIndex(
            where: {
                $0.id == note.id
            }
        ) {
            self.notes[item].title = note.title
            self.notes[item].text = note.text
            self.notes[item].date = Date()
        } else {
            self.notes.append(note)
        }
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
