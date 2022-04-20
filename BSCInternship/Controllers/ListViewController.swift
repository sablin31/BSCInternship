//
//  ListViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 07.04.2022.
//

import UIKit
// MARK: - ListViewController (RootView Controller)

class ListViewController: UIViewController {
    // MARK: - Public proterties

    var notes: [Note] = []
    // MARK: - Private proterties

    private let storage = DataStorage()
    // MARK: - UI Properties

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: Constants.titleLabelFrame)
        label.textColor = Constants.titleLabelTextColor
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
        tableView.register(NoteCell.self, forCellReuseIdentifier: ConstantsTableView.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var createNewNoteButton: UIButton = {
        let button = UIButton()
        button.frame = Constants.frameCreateNewNoteButton
        button.layer.cornerRadius = Constants.cornerRadiusCreateNewNoteButton * button.bounds.size.width
        button.setImage(UIImage(named: Constants.imageNameCreateNewNoteButton), for: .normal)
        button.addTarget(self, action: #selector(createNewNote), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Actions methods

    @objc func createNewNote() {
        let newNoteViewController = NoteViewController()
        newNoteViewController.delegate = self
        self.navigationController?.pushViewController(newNoteViewController, animated: true)
    }
    // MARK: - Init

    deinit {
        removeDidEnterBackgroundNotification()
    }
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        configureUI()
        setupDelegate()
        registerDidEnterBackgroundNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
// MARK: - Private methods

extension ListViewController {
    // MARK: Data storage methods

    private func loadNotes() {
        self.notes = storage.loadDate(key: Constants.dataStorageKey) ?? []
    }

    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { _ in
            self.storage.save(notes: self.notes, key: Constants.dataStorageKey)
        }
    }

    private func removeDidEnterBackgroundNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    // MARK: Configure UI

    private func configureUI() {
        self.navigationItem.titleView = titleLabel
        setupViews()
        setConstraints()
    }

    private func setupViews() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        view.addSubview(createNewNoteButton)
    }

    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: Set constraint

    private func setConstraints() {
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
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
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
            createNewNoteButton.widthAnchor.constraint(
                equalToConstant: Constants.createNewNoteButtonWidthAnchor
            ),
            createNewNoteButton.heightAnchor.constraint(
                equalToConstant: Constants.createNewNoteButtonHeightAnchor
            ),
            createNewNoteButton.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.createNewNoteButtonTrailingAnchor
            ),
            createNewNoteButton.bottomAnchor.constraint(
                equalTo: backgroundView.bottomAnchor,
                constant: Constants.createNewNoteButtonTrailingAnchor
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

        static let backgroundColor = UIColor(red: 0.976, green: 0.98, blue: 0.996, alpha: 1)

        static let titleLabelFrame = CGRect(x: 0, y: 0, width: 130, height: 22)
        static let titleLabelTextFont = UIFont(name: "SFProText-Semibold", size: 17)
        static let titleLabelTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let titleLabelText = "Заметки"

        static let frameCreateNewNoteButton = CGRect(x: 0, y: 0, width: 50, height: 50)
        static let cornerRadiusCreateNewNoteButton = 0.5
        static let imageNameCreateNewNoteButton = "roundButtonPlus.png"

        // MARK: Constraint constants

        static let tableViewLeadingAnchor: CGFloat = 10
        static let tableViewTrailingAnchor: CGFloat = -10

        static let createNewNoteButtonWidthAnchor: CGFloat = 50
        static let createNewNoteButtonHeightAnchor: CGFloat = 50
        static let createNewNoteButtonTrailingAnchor: CGFloat = -19
        static let createNewNoteButtonBottomAnchor: CGFloat = -69
    }
}
