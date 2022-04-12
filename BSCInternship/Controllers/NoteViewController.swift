//
//  MainViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // MARK: - Proterties

    var completionHandler: ((NoteProtocol) -> Void)?
    var currentNote: NoteProtocol?
    var indexNoteOnArray: Int?
    // MARK: - UI Properties

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @objc func checkNoteAndHideKeyboard() {
        view.endEditing(true)
        let title = (titleTextField.text?.isEmpty ?? true) ? nil : titleTextField.text
        let text = (noteTextView.text?.isEmpty ?? true) ? nil : noteTextView.text
        if title == nil, text == nil {
            showAlert()
        } else {
            currentNote?.date = Date()
            currentNote?.title = title
            currentNote?.text = text
            if let currentNote = currentNote {
                completionHandler?(currentNote)
            }
            // navigationController?.popViewController(animated: true)
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

        dateLabel.text = currentNote?.date.toString(dateFormat: Constants.dateFormat)
        titleTextField.text = currentNote?.title
        noteTextView.text = currentNote?.text

        titleTextField.autocorrectionType = .no
        noteTextView.autocorrectionType = .no
        noteTextView.becomeFirstResponder()
    }

    private func setNavigationBar() {
        let doneButtonNavigationBar: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setTitle(Constants.doneButtonNavigationBarTitle, for: .normal)
            button.addTarget(self, action: #selector(checkNoteAndHideKeyboard), for: .touchUpInside)
            // button.isHidden = true
            let menuBarItem = UIBarButtonItem(customView: button)
            return menuBarItem
        }()
        navigationItem.rightBarButtonItem = doneButtonNavigationBar
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.addSubview(dateLabel)
        backgroundView.addSubview(titleTextField)
        backgroundView.addSubview(noteTextView)
    }

    private func setupDelegate() {
        self.titleTextField.delegate = self
        self.noteTextView.delegate = self
    }

    // MARK: SetConstraints
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
                constant: 12
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: 20
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: -20
            )
        ])

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: 20
            ),
            titleTextField.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: 20
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: -20
            )
        ])

        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: noteTextView,
                attribute: .top,
                relatedBy: .equal,
                toItem: titleTextField,
                attribute: .bottom,
                multiplier: 1,
                constant: Constants.noteTextViewVerticalSpacing
            ),
            noteTextView.leadingAnchor.constraint(
                equalTo: backgroundView.leadingAnchor,
                constant: Constants.noteTextViewLeadingAnchor
            ),
            noteTextView.trailingAnchor.constraint(
                equalTo: backgroundView.trailingAnchor,
                constant: Constants.noteTextViewTrailingAnchor
            ),
            noteTextView.bottomAnchor.constraint(
                equalTo: backgroundView.bottomAnchor,
                constant: Constants.noteTextViewBottomAnchor
            )
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

        static let titleTextFieldTopAnchor: CGFloat = 5
        static let titleTextFieldLeadingAnchor: CGFloat = 5
        static let titleTextFieldTrailingAnchor: CGFloat = -5
        static let dataPickerVerticalSpacing: CGFloat = 10
        static let dataPickerLeadingAnchor: CGFloat = 10
        static let dataPickerTrailingAnchor: CGFloat = -5
        static let noteTextViewVerticalSpacing: CGFloat = 28
        static let noteTextViewBottomAnchor: CGFloat = -20
        static let noteTextViewLeadingAnchor: CGFloat = 20
        static let noteTextViewTrailingAnchor: CGFloat = -20
    }
}
