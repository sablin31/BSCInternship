//
//  ListViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 07.04.2022.
//

import UIKit
// MARK: - ListViewController (RootView Controller)

final class ListViewController: UIViewController, UITableViewDelegate {
    // MARK: - Public proterties

    var notesInDevice: [Note] = []
    var notesInWeb: [Note] = []
    // MARK: - Private proterties

    private let storageWorker = WorkerStorage()
    private let webWorker = WorkerWeb()
    // MARK: - UI Properties

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: Constants.titleLabelFrame)
        label.font = Constants.titleLabelTextFont
        label.text = Constants.titleLabelText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseId)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var createOrDeleteNoteButton: UIButton = {
        let button = UIButton()
        button.frame = Constants.frameCreateOrDeleteNoteButton
        button.layer.cornerRadius = Constants.cornerRadiusCreateOrDeleteNoteButton * button.bounds.size.width
        button.setImage(UIImage(named: Constants.imageCreateForCreateOrDeleteNoteButton), for: .normal)
        button.addTarget(self, action: #selector(createOrDeleteNote), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var rightButtonNavigationBar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.chooseRightButtonNavigationBarTitle, for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonAction), for: .touchUpInside)
        return button
    }()
    // MARK: - Actions methods

    @objc func createOrDeleteNote() {
        if isEditing == false {
            tableView.setEditing(false, animated: true)
            UIView.transition(
                with: createOrDeleteNoteButton,
                duration: Constants.buttonAnimationDurationUp,
                options: .curveLinear,
                animations: { [weak self] in guard let self = self else { return }
                    self.createOrDeleteNoteButton.frame.origin.y -= Constants.buttonAnimationPositionUp
                }, completion: {_ in
                    UIView.transition(
                        with: self.createOrDeleteNoteButton,
                        duration: Constants.buttonAnimationDurationDown,
                        options: .curveLinear,
                        animations: { [weak self] in guard let self = self else { return }
                            self.createOrDeleteNoteButton.frame.origin.y = UIScreen.main.bounds.maxY
                        }, completion: { _ in self.createNote() }
                    )
                }
            )
        } else { deleteNote() }
    }

    @objc func rightBarButtonAction() {
        tableView.setEditing(false, animated: true)
        if notesInDevice.isEmpty {
            showAlert(
                titleMessage: Constants.titleAlert,
                message: Constants.messageAlertNotNotes,
                titleButton: Constants.titleOkButtonAlert
            )
        } else { isEditing ? setEditing(false, animated: true) : setEditing(true, animated: true) }
    }
    // MARK: - Init

    deinit { removeDidEnterBackgroundNotification() }
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        readNotes()
        configureUI()
        setupDelegate()
        registerDidEnterBackgroundNotification()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        if isEditing == true {
            rightButtonNavigationBar.setTitle(Constants.chooseRightButtonNavigationBarTitle, for: .normal)
            createOrDeleteNoteButton.setImage(
                UIImage(named: Constants.imageCreateForCreateOrDeleteNoteButton), for: .normal
            )
            UIView.transition(
                with: createOrDeleteNoteButton,
                duration: Constants.transitionButtonAnimationDuration,
                options: .transitionFlipFromLeft,
                animations: nil,
                completion: nil
            )
            tableView.setEditing(false, animated: true)
        } else {
            rightButtonNavigationBar.setTitle(Constants.doneRightButtonNavigationBarTitle, for: .normal)
            createOrDeleteNoteButton.setImage(
                UIImage(named: Constants.imageDeleteForCreateOrDeleteNoteButton), for: .normal
            )
            UIView.transition(
                with: createOrDeleteNoteButton,
                duration: Constants.transitionButtonAnimationDuration,
                options: .transitionFlipFromLeft,
                animations: nil,
                completion: nil
            )
            tableView.setEditing(true, animated: true)
        }
        super.setEditing(editing, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        UIView.animate(
            withDuration: Constants.buttonAnimationWithDuration,
            delay: Constants.buttonAnimationDelay,
            usingSpringWithDamping: Constants.buttonAnimationUsingSpringWithDamping,
            initialSpringVelocity: Constants.buttonAnimationInitialSpringVelocity,
            options: [],
            animations: { [weak self] in guard let self = self else { return }
                self.createOrDeleteNoteButton.bounds.origin.y -= Constants.buttonAnimatioPosition
            },
            completion: nil
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                changeColorUI(to: traitCollection.userInterfaceStyle)
                tableView.reloadData()
            }
        }
    }
}
// MARK: - UITableViewDataSource

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
// MARK: - UITableViewDelegate methods

extension ListViewController {
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
// MARK: - Private methods

private extension ListViewController {
    // MARK: CRuD methods
    func createNote() {
        let newNoteViewController = NoteViewController()
        newNoteViewController.delegate = self
        navigationController?.pushViewController(newNoteViewController, animated: true)
    }

    func readNotes() {
        notesInDevice = storageWorker.loadDate(key: Constants.dataStorageKey) ?? []
        webWorker.fetch { [weak self] notes in
            guard let notes = notes else { return }
            if notes.isEmpty == false {
                for note in notes {
                    let newNote = Note(
                        title: note.title,
                        text: note.text,
                        date: note.date ?? Date()
                    )
                    self?.notesInWeb.append(newNote)
                }
                self?.tableView.reloadData()
            }
        }
    }

    func deleteNote() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            showAlert(
                titleMessage: Constants.titleAlert,
                message: Constants.messageAlertNoteNotChecked,
                titleButton: Constants.titleOkButtonAlert
            )
            return
        }
        var deleteNotes = [Note]()
        for indexPath in selectedRows {
            if indexPath.section == Constants.notesInDeviceNumberOfSection {
                deleteNotes.append(notesInDevice[indexPath.row])
            }
            if indexPath.section == Constants.notesInWebNumberOfSection {
                deleteNotes.append(notesInWeb[indexPath.row])
            }
        }
        for deleteNote in deleteNotes {
            if let index = notesInDevice.firstIndex(of: deleteNote) {
                notesInDevice.remove(at: index)
            }
            if let index = notesInWeb.firstIndex(of: deleteNote) {
                notesInWeb.remove(at: index)
            }
        }
        tableView.beginUpdates()
        tableView.deleteRows(at: selectedRows, with: .automatic)
        tableView.endUpdates()
        setEditing(false, animated: true)
    }

    func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { _ in
            self.storageWorker.save(notes: self.notesInDevice, key: Constants.dataStorageKey)
        }
    }

    func removeDidEnterBackgroundNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    // MARK: Configure UI
    func configureUI() {
        navigationItem.titleView = titleLabel
        setupViews()
        changeColorUI(to: traitCollection.userInterfaceStyle)
        setNavigationBar()
        setConstraints()
    }

    func setupViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        view.addSubview(createOrDeleteNoteButton)
    }

    func changeColorUI(to currentUserInterfaceStyle: UIUserInterfaceStyle) {
        if currentUserInterfaceStyle == .dark {
            view.backgroundColor = Constants.backgroundColorDark
            titleLabel.textColor = Constants.titleLabelTextColorDark
        } else {
            view.backgroundColor = Constants.backgroundColorLight
            titleLabel.textColor = Constants.titleLabelTextColorLight
        }
    }

    func setNavigationBar() {
        navigationController?.navigationBar.setValue(true, forKey: Constants.navigationBarPropertiesKey)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButtonNavigationBar)
    }

    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
// MARK: - Set constraint

extension ListViewController {
    func setConstraints() {
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: guide.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: backgroundView.topAnchor,
                constant: Constants.tableViewTopAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.tableViewLeadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.tableViewTrailingAnchor
            ),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            createOrDeleteNoteButton.widthAnchor.constraint(
                equalToConstant: Constants.createOrDeleteNoteButtonWidthAnchor
            ),
            createOrDeleteNoteButton.heightAnchor.constraint(
                equalToConstant: Constants.createOrDeleteNoteButtonHeightAnchor
            ),
            createOrDeleteNoteButton.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.createOrDeleteNoteButtonTrailingAnchor
            ),
            createOrDeleteNoteButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: Constants.createOrDeleteNoteButtonBottomAnchor
            )
        ])
    }
}
// MARK: - Constants
extension ListViewController {
    private enum Constants {
        // MARK: Data storage constants
        static let dataStorageKey = "notes"

        // MARK: UI Properties constants
        static let backgroundColorLight = UIColor(red: 0.976, green: 0.98, blue: 0.996, alpha: 1)
        static let backgroundColorDark = UIColor.darkGray

        static let chooseRightButtonNavigationBarTitle = "Выбрать"
        static let doneRightButtonNavigationBarTitle = "Готово"

        static let navigationBarPropertiesKey = "hidesShadow"

        static let titleLabelFrame = CGRect(x: 0, y: 0, width: 130, height: 22)
        static let titleLabelTextFont = UIFont(name: "SFProText-Semibold", size: 17)
        static let titleLabelTextColorLight = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let titleLabelTextColorDark = UIColor.white
        static let titleLabelText = "Заметки"

        static let frameCreateOrDeleteNoteButton = CGRect(x: 0, y: 0, width: 50, height: 50)
        static let cornerRadiusCreateOrDeleteNoteButton = 0.5
        static let imageCreateForCreateOrDeleteNoteButton = "buttonAdd.pdf"
        static let imageDeleteForCreateOrDeleteNoteButton = "buttonRemove.pdf"
        static let transitionButtonAnimationDuration = 0.3

        static let swipeDeleteNoteTitle = "Удалить"
        static let swipeDeleteNoteImageSystemName = "trash"
        static let swipeDeleteNoteImagePointSize: CGFloat = 20.0

        static let heightForRowAt = 90.0
        static let numbersOfSections = 2
        static let notesInDeviceNumberOfSection = 0
        static let notesInDeviceTitleSection = "Заметки на устройстве"
        static let notesInWebNumberOfSection = 1
        static let notesInWebTitleSection = "Заметки из сети"

        static let titleAlert = "Предупреждение"
        static let messageAlertNoteNotChecked = "Вы не выбрали ни одной заметки"
        static let messageAlertNotNotes = "Создайте хотя бы одну заметку"
        static let titleOkButtonAlert = "OK"

        // MARK: Animations constants
        static let buttonAnimationWithDuration = 1.5
        static let buttonAnimationDelay = 0.2
        static let buttonAnimationUsingSpringWithDamping = 0.1
        static let buttonAnimationInitialSpringVelocity: CGFloat = 3
        static let buttonAnimatioPosition = Constants.createOrDeleteNoteButtonBottomAnchor * 2

        static let buttonAnimationDurationUp = 0.5
        static let buttonAnimationPositionUp: CGFloat = 100
        static let buttonAnimationDurationDown = 0.15

        // MARK: Constraints constants
        static let tableViewTopAnchor: CGFloat = 16
        static let tableViewLeadingAnchor: CGFloat = 10
        static let tableViewTrailingAnchor: CGFloat = -10

        static let createOrDeleteNoteButtonWidthAnchor: CGFloat = 50
        static let createOrDeleteNoteButtonHeightAnchor: CGFloat = 50
        static let createOrDeleteNoteButtonTrailingAnchor: CGFloat = -20
        static let createOrDeleteNoteButtonBottomAnchor: CGFloat = -60
    }
}
