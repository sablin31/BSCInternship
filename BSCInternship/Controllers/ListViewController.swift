//
//  ListViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 07.04.2022.
//

import UIKit

// MARK: - Protocol delegate

protocol ListViewControllerDelegate: AnyObject {
    func setCurrentModel(_ model: [NoteProtocol]?)
    func getUpdateModel() -> [NoteProtocol]?
}
// MARK: - ListViewController (RootView Controller)

class ListViewController: UIViewController {
    // MARK: - Public proterties

    weak var delegate: ListViewControllerDelegate?
    var notes: [NoteProtocol]?
    var noteViews: [NoteView] = []
    // MARK: - Private proterties

    private let screenWidth = UIScreen.main.bounds.width
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
        scrollView.isScrollEnabled = true
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

    // MARK: - Actions methods

    @objc func createNewNote() {
        let newNoteViewController = NoteViewController()
        delegate = newNoteViewController
        delegate?.setCurrentModel(notes)
        self.navigationController?.pushViewController(newNoteViewController, animated: true)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let currentNoteView = sender?.view as? NoteView else { return }

        let currentNoteViewControler = NoteViewController()
        delegate = currentNoteViewControler

        let currentNote = currentNoteView.note
        // Определение заметки которая была выбрана
        if let selectedNote = notes?.first(
            where: {
                $0 as? Note === currentNote as? Note
            }
        ) {
            // Передача выбранной заметки во 2-ю вью
            currentNoteViewControler.currentNote = selectedNote
            delegate?.setCurrentModel(notes)
        }
        self.navigationController?.pushViewController(currentNoteViewControler, animated: true)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let updateModel = delegate?.getUpdateModel()
        if updateModel != nil {
            self.notes = updateModel
            updateStackView()
            stackView.layoutIfNeeded()
            scrollView.contentSize = CGSize(width: screenWidth, height: stackView.bounds.height)
        }
    }
}
// MARK: - Private methods

extension ListViewController {
    // MARK: Data storage methods

    private func loadNotes() {
        self.notes = storage.loadDate(key: Constants.dataStorageKey)
        if let notes = notes {
            for note in notes {
                noteViews.append(NoteView(note: note))
            }
        }
    }

    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { _ in
            if self.notes != nil {
                if let notes = self.notes {
                    self.storage.save(notes: notes, key: Constants.dataStorageKey)
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

        for noteView in noteViews {
            addNoteViewInStack(noteView: noteView, in: stackView)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func addNoteViewInStack(noteView: NoteView, in stack: UIStackView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        noteView.addGestureRecognizer(tap)
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

    private func updateStackView() {
        if let notes = notes {
            for note in notes {
                if self.noteViews.isEmpty == false {
                    if let selectedNoteView = self.noteViews.first(
                        where: {
                            $0.note as? Note === note as? Note
                        }
                    ) {
                        selectedNoteView.updateView()
                    } else {
                        let newNoteView = NoteView(note: note)
                        self.noteViews.append(newNoteView)
                        addNoteViewInStack(noteView: newNoteView, in: stackView)
                    }
                } else {
                    let newNoteView = NoteView(note: note)
                    self.noteViews = [newNoteView]
                    addNoteViewInStack(noteView: newNoteView, in: stackView)
                }
            }
        }
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
