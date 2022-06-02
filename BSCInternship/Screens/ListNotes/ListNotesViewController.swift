//
//  ListViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 07.04.2022.
//
//  ViewController

import UIKit

protocol ListNotesDisplayLogic: AnyObject {
    func showNotesInStorage(viewModel: ListNotesModel.GetNotesInStorage.ViewModel)
    func showNotesInWeb(viewModel: ListNotesModel.GetNotesInWeb.ViewModel)
    func showAllNotice(viewModel: ListNotesModel.GetModel.ViewModel)
    func showAllNotesAfterDelete(viewModel: ListNotesModel.DeleteNotes.ViewModel)
    func showAllNotesAfterSave(viewModel: ListNotesModel.SaveAllNotice.ViewModel)
}

final class ListNotesViewController: UIViewController {
    // MARK: - Public proterties

    var notesModel = NotesModel()
    var interactor: ListNotesInteractor?
    var router: RouterProtocol?
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
        button.addTarget(self, action: #selector(selectNoteOrDoneEditing), for: .touchUpInside)
        return button
    }()

    private var spinner: UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    // MARK: - Actions methods

    @objc func createOrDeleteNote() {
        if isEditing == false {
            tableView.setEditing(false, animated: true)
            upDownAnimationView(
                with: createOrDeleteNoteButton.self,
                durationUp: Constants.buttonAnimationDurationUp,
                durationDown: Constants.buttonAnimationDurationDown,
                positionUp: Constants.buttonAnimationPositionUp,
                completion: { _ in self.router?.routeToDetailNoteController(with: nil, dataStore: self.interactor) }
            )
        } else { deleteNotes() }
    }

    @objc func selectNoteOrDoneEditing() {
        tableView.setEditing(false, animated: true)
        if notesModel.notesInWeb.isEmpty && notesModel.notesInDevice.isEmpty {
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
        setDelegate()
        configureUI()
        getNoticeInStorage()
        getNoticeInWeb()
        registerDidEnterBackgroundNotification()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        if isEditing == true {
            rightButtonNavigationBar.setTitle(Constants.chooseRightButtonNavigationBarTitle, for: .normal)
            createOrDeleteNoteButton.setImage(
                UIImage(named: Constants.imageCreateForCreateOrDeleteNoteButton), for: .normal
            )
            rotateView(with: createOrDeleteNoteButton, duration: Constants.transitionButtonAnimationDuration)
            tableView.setEditing(false, animated: true)
        } else {
            rightButtonNavigationBar.setTitle(Constants.doneRightButtonNavigationBarTitle, for: .normal)
            createOrDeleteNoteButton.setImage(
                UIImage(named: Constants.imageDeleteForCreateOrDeleteNoteButton), for: .normal
            )
            rotateView(with: createOrDeleteNoteButton, duration: Constants.transitionButtonAnimationDuration)
            tableView.setEditing(true, animated: true)
        }
        super.setEditing(editing, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
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

extension ListNotesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numbersOfSections
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForRowAt
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Constants.notesInDeviceNumberOfSection {
            return notesModel.notesInDevice.count
        }
        if section == Constants.notesInWebNumberOfSection {
            return notesModel.notesInWeb.count
        } else { return 0 }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseId) as? NoteCell
        let note = indexPath.section == Constants.notesInDeviceNumberOfSection ?
        notesModel.notesInDevice[indexPath.row] : notesModel.notesInWeb[indexPath.row]
        cell?.set(with: note)
        return cell ?? UITableViewCell()
    }
}
// MARK: - UITableViewDelegate methods

extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing == false {
            var currentNote: Note?
            if indexPath.section == Constants.notesInDeviceNumberOfSection {
                currentNote = notesModel.notesInDevice[indexPath.row]
            }
            if indexPath.section == Constants.notesInWebNumberOfSection {
                currentNote = notesModel.notesInWeb[indexPath.row]
            }
            router?.routeToDetailNoteController(with: currentNote, dataStore: interactor)
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: nil) {
            _, _, _ in
            var selectedRows = [IndexPath]()
            selectedRows.append(indexPath)
            let request = ListNotesModel.DeleteNotes.Request(selectedRows: selectedRows)
            self.interactor?.deleteNotes(request: request)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
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
// MARK: - ListNotesDisplayLogic

extension ListNotesViewController: ListNotesDisplayLogic {
    func showNotesInStorage(viewModel: ListNotesModel.GetNotesInStorage.ViewModel) {
        self.notesModel = viewModel.notesModel
        tableView.reloadData()
    }

    func showNotesInWeb(viewModel: ListNotesModel.GetNotesInWeb.ViewModel) {
        if spinner.isAnimating { spinner.stopAnimating() }
        self.notesModel = viewModel.notesModel
        tableView.reloadData()
    }

    func showAllNotesAfterDelete(viewModel: ListNotesModel.DeleteNotes.ViewModel) {
        self.notesModel = viewModel.notesModel
    }

    func showAllNotice(viewModel: ListNotesModel.GetModel.ViewModel) {
        self.notesModel = viewModel.notesModel
        tableView.reloadData()
    }

    func showAllNotesAfterSave(viewModel: ListNotesModel.SaveAllNotice.ViewModel) {
        print("All notese in device is save in UserDefaults")
    }
}
// MARK: - Private methods

private extension ListNotesViewController {
    func getNoticeInStorage() {
        let request = ListNotesModel.GetNotesInStorage.Request(keyDataSource: Constants.keyDataSource)
        interactor?.getNotesInStorage(request: request)
    }

    func getNoticeInWeb() {
        spinner.startAnimating()
        let request = ListNotesModel.GetNotesInWeb.Request(url: Constants.createURLComponents())
        interactor?.getNotesInWeb(request: request)
    }

    func updateData() {
        let request = ListNotesModel.GetModel.Request()
        interactor?.getAllNotice(request: request) }

    func deleteNotes() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            showAlert(
                titleMessage: Constants.titleAlert,
                message: Constants.messageAlertNoteNotChecked,
                titleButton: Constants.titleOkButtonAlert
            )
            return
        }
        let request = ListNotesModel.DeleteNotes.Request(selectedRows: selectedRows)
        interactor?.deleteNotes(request: request)
        tableView.beginUpdates()
        tableView.deleteRows(at: selectedRows, with: .automatic)
        tableView.endUpdates()
        setEditing(false, animated: true)
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
        view.addSubview(spinner)
    }

    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
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

    // MARK: Save data after close app

    func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { _ in
            let request = ListNotesModel.SaveAllNotice.Request(keyDataSource: Constants.keyDataSource)
            self.interactor?.saveAllNotice(request: request)
        }
    }

    func removeDidEnterBackgroundNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
}
// MARK: - Set constraint

extension ListNotesViewController {
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

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
// MARK: - Constants

extension ListNotesViewController {
    private enum Constants {
        // MARK: Data storage constants
        static let keyDataSource = "notes"

        // MARK: URL сonstant
        static func createURLComponents() -> URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "firebasestorage.googleapis.com"
            urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
            urlComponents.queryItems = [
                URLQueryItem(name: "alt", value: "media"),
                URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
            ]
            return urlComponents.url
        }

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
