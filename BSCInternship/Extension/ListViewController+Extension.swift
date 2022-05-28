//
//  ListViewController+Extension.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 26.05.2022.
//

import UIKit

// MARK: - UITableViewDelegate methods

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing == false {
            let currentNoteViewControler = NoteViewController()
            currentNoteViewControler.delegate = self
            if indexPath.section == Constants.notesInDeviceNumberOfSection {
                currentNoteViewControler.currentNote = notesInDevice[indexPath.row]
            } else {
                currentNoteViewControler.currentNote = notesInWeb[indexPath.row]
            }
            navigationController?.pushViewController(currentNoteViewControler, animated: true)
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: nil) {
            _, _, _ in
            if indexPath.section == Constants.notesInDeviceNumberOfSection {
                self.notesInDevice.remove(at: indexPath.row)
            } else { self.notesInWeb.remove(at: indexPath.row) }
            tableView.reloadData()
        }

        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: Constants.swipeDeleteNoteImagePointSize,
            weight: .bold,
            scale: .large
        )
        actionDelete.image = UIImage(
            systemName: Constants.swipeDeleteNoteImageSystemName,
            withConfiguration: imageConfig
        )?.withTintColor(
            .white,
            renderingMode: .alwaysTemplate
        ).addBackgroundCircle(.systemRed)

        actionDelete.backgroundColor = traitCollection.userInterfaceStyle == .dark ?
        Constants.backgroundColorDark : Constants.backgroundColorLight
        actionDelete.title = Constants.swipeDeleteNoteTitle

        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}
// MARK: - UITableViewDataSource methods

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return Constants.numbersOfSections }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForRowAt
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Constants.notesInDeviceNumberOfSection {
            return notesInDevice.count
        } else { return notesInWeb.count }
    }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Constants.notesInDeviceNumberOfSection {
            return notesInDevice.isEmpty == false ? Constants.notesInDeviceTitleSection : nil
        } else {
            return notesInWeb.isEmpty == false ? Constants.notesInWebTitleSection : nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseId) as? NoteCell
        let note: Note
        if indexPath.section == Constants.notesInDeviceNumberOfSection {
            note = notesInDevice[indexPath.row]
        } else { note = notesInWeb[indexPath.row] }
        cell?.set(with: note)
        return cell ?? UITableViewCell()
    }
}
// MARK: - NoteViewControllerDelegate methods (Update data)

extension ListViewController: NoteViewControllerDelegate {
    func noteWasChanged(with note: Note) {
        if let item = self.notesInDevice.firstIndex( where: { $0.id == note.id }) {
            self.notesInDevice[item].title = note.title
            self.notesInDevice[item].text = note.text
            self.notesInDevice[item].date = Date()
        } else {
            if let item = self.notesInWeb.firstIndex( where: { $0.id == note.id }) {
                self.notesInWeb[item].title = note.title
                self.notesInWeb[item].text = note.text
                self.notesInWeb[item].date = Date()
            } else { self.notesInDevice.append(note) }
        }
    }
}

// MARK: - Constants
extension ListViewController {
    private enum Constants {
        // MARK: UI Properties constants
        static let backgroundColorLight = UIColor(red: 0.976, green: 0.98, blue: 0.996, alpha: 1)
        static let backgroundColorDark = UIColor.darkGray

        // MARK: Delegate constants
        static let swipeDeleteNoteTitle = "Удалить"
        static let swipeDeleteNoteImageSystemName = "trash"
        static let swipeDeleteNoteImagePointSize: CGFloat = 20.0
        static let heightForRowAt = 90.0
        static let numbersOfSections = 2
        static let notesInDeviceNumberOfSection = 0
        static let notesInDeviceTitleSection = "Заметки на устройстве"
        static let notesInWebNumberOfSection = 1
        static let notesInWebTitleSection = "Заметки из сети"
    }
}
