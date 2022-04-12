//
//  ListViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 07.04.2022.
//

import UIKit
// MARK: - ListViewController (Main Controller)

class ListViewController: UIViewController {
    // MARK: - Public proterties

    weak var delegate: NoteDelegate?
    var notes: [NoteProtocol]?
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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var stackView = UIStackView()

    private lazy var createNewNoteButton: UIButton = {
        let button = UIButton()
        button.frame = Constants.frameCreateNewNoteButton
        button.layer.cornerRadius = Constants.cornerRadiusCreateNewNoteButton * button.bounds.size.width
        button.setImage(UIImage(named: Constants.imageNameCreateNewNoteButton), for: .normal)
        button.addTarget(self, action: #selector(createNewNote), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: Actions methods

    @objc func createNewNote() {
        let newNoteViewController = NoteViewController()
        newNoteViewController.currentNote = Note()
        newNoteViewController.completionHandler = { [unowned self] newNote in
            if self.notes != nil {
                self.notes?.append(newNote)
            } else {
                self.notes = [NoteProtocol]()
                notes?.append(newNote)
            }
            addNoteViewInStack(noteView: NoteView(note: newNote), tag: (notes?.count ?? 1) - 1, in: stackView)
        }
        self.navigationController?.pushViewController(newNoteViewController, animated: true)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let numberOfNote = sender?.view?.tag else { return }
        if notes != nil, numberOfNote >= 0 && numberOfNote < notes?.count ?? 0 {
            let selectedNote = notes?[numberOfNote]
            delegate = selectedNote.self
            let currentNoteViewControler = NoteViewController()
            currentNoteViewControler.currentNote = selectedNote
            currentNoteViewControler.completionHandler = { [unowned self] modifiedNote in
                delegate?.updateData(data: modifiedNote)
                for item in 0..<(stackView.arrangedSubviews.count) {
                    let currentNoteView = stackView.arrangedSubviews[item] as? NoteView
                    if currentNoteView?.note === selectedNote {
                        currentNoteView?.updateView()
                    }
                }
            }
            self.navigationController?.pushViewController(currentNoteViewControler, animated: true)
        }
    }
    // MARK: - Init

    deinit {
        removeDidEnterBackgroundNotification()
    }
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        loadNotes()
        configureUI()
        registerDidEnterBackgroundNotification()
    }
}
// MARK: - Private methods

extension ListViewController {
    // MARK: Data storage methods

    private func loadNotes() {
        self.notes = storage.loadDate(key: Constants.dataStorageKey)
    }

    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { _ in
            if self.notes != nil {
                if let notes1 = self.notes {
                    for items in notes1 {
                        print(items.title)
                    }
                    self.storage.save(notes: notes1, key: Constants.dataStorageKey)
                }
            }
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
        let screenWidth = UIScreen.main.bounds.width

        view.addSubview(backgroundView)
        backgroundView.addSubview(scrollView)
        stackView = configureStackView()
        scrollView.addSubview(stackView)
        stackView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: screenWidth, height: stackView.bounds.height)
        view.addSubview(createNewNoteButton)
    }

    private func configureStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constants.stackViewSpacing

        for item in 0..<(notes?.count ?? 0) {
            if let currenNote = notes?[item] {
                let currentNoteView = NoteView(note: currenNote)
                addNoteViewInStack(noteView: currentNoteView, tag: item, in: stackView)
            }
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func addNoteViewInStack(noteView: NoteView, tag: Int, in stack: UIStackView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        noteView.addGestureRecognizer(tap)
        noteView.tag = tag
        stack.addArrangedSubview(noteView)
        NSLayoutConstraint.activate([
            noteView.heightAnchor.constraint(equalToConstant: Constants.stackViewContentHeight),
            noteView.leadingAnchor.constraint(
                equalTo: stack.leadingAnchor,
                constant: Constants.stackViewContentLeadingAnchor
            ),
            noteView.trailingAnchor.constraint(
                equalTo: stack.trailingAnchor,
                constant: Constants.stackViewContentTrailingAnchor
            )
        ])
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
            scrollView.topAnchor.constraint(
                equalTo: backgroundView.topAnchor,
                constant: Constants.scrollViewTopAnchor
            ),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
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

        static let stackViewSpacing: CGFloat = 4

        static let frameCreateNewNoteButton = CGRect(x: 0, y: 0, width: 50, height: 50)
        static let cornerRadiusCreateNewNoteButton = 0.5
        static let imageNameCreateNewNoteButton = "roundButtonPlus.png"

        // MARK: Constraint constants

        static let scrollViewTopAnchor: CGFloat = 26

        static let stackViewContentHeight: CGFloat = 90
        static let stackViewContentLeadingAnchor: CGFloat = 16
        static let stackViewContentTrailingAnchor: CGFloat = -16

        static let createNewNoteButtonWidthAnchor: CGFloat = 50
        static let createNewNoteButtonHeightAnchor: CGFloat = 50
        static let createNewNoteButtonTrailingAnchor: CGFloat = -19
        static let createNewNoteButtonBottomAnchor: CGFloat = -69
    }
}
