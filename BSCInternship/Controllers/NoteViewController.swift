//
//  MainViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import UIKit
// MARK: - Protocol delegate

protocol NoteViewControllerDelegate: AnyObject {
    func noteWasChanged(with note: Note)
}
// MARK: - ListViewController (SecondView Controller)

class NoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // MARK: - Proterties

    var currentNote: Note?
    var editMode = false
    weak var delegate: NoteViewControllerDelegate?
    // MARK: - UI Properties

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.dateLabelTextColor
        label.font = Constants.dateLabelTextFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = Constants.titleTextFieldFont
        textField.borderStyle = .none
        textField.placeholder = Constants.titleTextFieldPlaceholder
        textField.textAlignment = .left
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = Constants.noteTextViewFont
        textView.textAlignment = .left
        textView.showsVerticalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var backButtonNavigationBar: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.backButtonNavigationBarImageSystemName), for: .normal)
        button.addTarget(self, action: #selector(leftBarButtonAction), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }()

    private lazy var doneButtonNavigationBar: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.doneButtonNavigationBarTitle, for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonAction), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }()
    // MARK: - Init

    deinit {
        removeKeyboardNotification()
    }
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        configureUI()
        registerKeyboardNotification()
    }

    @objc override func keyboardWillShow(notification: Notification) {
        self.editMode = true
        navigationItem.rightBarButtonItem = doneButtonNavigationBar
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = noteTextView.convert(keyboardScreenEndFrame, from: noteTextView.window)

        noteTextView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardViewEndFrame.height - noteTextView.safeAreaInsets.bottom,
            right: 0
        )
    }

    @objc override func keyboardWillHide(notification: Notification) {
        self.editMode = false
        noteTextView.contentInset = .zero
        let newPosition = noteTextView.beginningOfDocument
        noteTextView.selectedTextRange = noteTextView.textRange(from: newPosition, to: newPosition)
        navigationItem.rightBarButtonItem = nil
    }

    // MARK: - Actions methods

    @objc func leftBarButtonAction() {
        let title = (titleTextField.text?.isEmpty ?? true) ? nil : titleTextField.text
        let text = (noteTextView.text?.isEmpty ?? true) ? nil : noteTextView.text
        if (title != nil || text != nil) && editMode {
            updateModel(title: title, text: text)
        }
        self.navigationController?.popViewController(animated: true)
    }

    @objc func rightBarButtonAction() {
        view.endEditing(true)
        let title = (titleTextField.text?.isEmpty ?? true) ? nil : titleTextField.text
        let text = (noteTextView.text?.isEmpty ?? true) ? nil : noteTextView.text
        if title == nil, text == nil {
            showAlert()
        } else {
            updateModel(title: title, text: text)
        }
    }
}
// MARK: - Private Methods

extension NoteViewController {
    private func configureUI() {
        setupViews()
        setNavigationBar()
        setConstraints()
        setupDelegate()

        dateLabel.text = currentNote?.date.toString(
            dateFormat: Constants.dateFormat
        ) ?? Date().toString(
            dateFormat: Constants.dateFormat
        )
        titleTextField.text = currentNote?.title
        noteTextView.text = currentNote?.text

        titleTextField.autocorrectionType = .no
        noteTextView.autocorrectionType = .no
        if self.currentNote == nil { noteTextView.becomeFirstResponder() }
    }

    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = backButtonNavigationBar
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.addSubview(dateLabel)
        backgroundView.addSubview(titleTextField)
        backgroundView.addSubview(scrollView)
        scrollView.addSubview(noteTextView)
    }

    private func setupDelegate() {
        self.titleTextField.delegate = self
        self.noteTextView.delegate = self
    }

    private func updateModel(title: String?, text: String?) {
        if currentNote != nil {
            currentNote?.title = title
            currentNote?.text = text
            currentNote?.date = Date()
        } else {
            currentNote = Note(title: title, text: text)
        }
        if let currentNote = currentNote {
            delegate?.noteWasChanged(with: currentNote)
            dateLabel.text = currentNote.date.toString(dateFormat: Constants.dateFormat)
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
            dateLabel.topAnchor.constraint(
                equalTo: backgroundView.topAnchor,
                constant: Constants.dataLabelTopAnchor
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.dataLabelLeadingAnchor
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.dataLabelTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: Constants.titleTextFieldTopAnchor
            ),
            titleTextField.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.titleTextFieldLeadingAnchor
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.titleTextFieldTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: scrollView,
                attribute: .top,
                relatedBy: .equal,
                toItem: titleTextField,
                attribute: .bottom,
                multiplier: 1,
                constant: Constants.scrollViewVerticalSpacing
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.scrollViewLeadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.scrollViewTrailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: backgroundView.bottomAnchor,
                constant: Constants.scrollViewBottomAnchor
            )
        ])

        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            noteTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            noteTextView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    private func showAlert() {
        let dialogMessage = UIAlertController(
            title: Constants.titleAlert,
            message: Constants.messageAlert,
            preferredStyle: .alert
        )

        let okButton = UIAlertAction(
            title: Constants.titleOkButtonAlert,
            style: .default
        )

        dialogMessage.addAction(okButton)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
// MARK: - Constants

extension NoteViewController {
    private enum Constants {
        // MARK: UI Properties constants

        static let backgroundColor = UIColor(red: 0.976, green: 0.98, blue: 0.996, alpha: 1)

        static let backButtonNavigationBarImageSystemName = "chevron.backward"
        static let doneButtonNavigationBarTitle = "Готово"

        static let dateFormat = "dd.MM.yyyy EEEE HH:mm"

        static let dateLabelFrame = CGRect(x: 0, y: 0, width: 130, height: 22)
        static let dateLabelTextFont = UIFont(name: "SFProText-Medium", size: 16)
        static let dateLabelTextColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)

        static let titleTextFieldPlaceholder = "Введите название"
        static let titleTextFieldFont = UIFont(name: "SFProText-Medium", size: 24)

        static let noteTextViewFont = UIFont(name: "SFProText-Medium", size: 16)

        static let titleAlert = "Предупреждение"
        static let messageAlert = "Оба поля заметки не могут быть пустыми"
        static let titleOkButtonAlert = "OK"

        // MARK: Constraint constants

        static let dataLabelTopAnchor: CGFloat = 12
        static let dataLabelLeadingAnchor: CGFloat = 20
        static let dataLabelTrailingAnchor: CGFloat = -20

        static let titleTextFieldTopAnchor: CGFloat = 20
        static let titleTextFieldLeadingAnchor: CGFloat = 20
        static let titleTextFieldTrailingAnchor: CGFloat = -20

        static let scrollViewVerticalSpacing: CGFloat = 28
        static let scrollViewLeadingAnchor: CGFloat = 20
        static let scrollViewTrailingAnchor: CGFloat = -20
        static let scrollViewBottomAnchor: CGFloat = -20
    }
}
