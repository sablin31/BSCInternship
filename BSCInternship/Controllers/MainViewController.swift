//
//  MainViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import UIKit

class MainViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // MARK: - Proterties
    private let storage = DataStorage()

    private var currentNote: NoteProtocol?

    private let bodyContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: StringConstants.titleTextFieldFontSize, weight: UIFont.Weight.bold)
        textField.borderStyle = .none
        textField.placeholder = StringConstants.titleTextFieldPlaceholder
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    private let dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: StringConstants.dateTextFieldFontSize, weight: UIFont.Weight.regular)
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: StringConstants.noteTextViewFontSize, weight: UIFont.Weight.regular)
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    // MARK: - Init
    deinit {
        removeDidEnterBackgroundNotification()
    }
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerDidEnterBackgroundNotification()
    }

    @objc func checkNoteAndHideKeyboard() {
        view.endEditing(true)
        let title = titleTextField.text == "" ? nil : titleTextField.text
        let text = noteTextView.text == "" ? nil : noteTextView.text
        let date = dateTextField.text == "" ? Date() : datePicker.date
        if currentNote == nil {
        currentNote = Note(
            title: title,
            text: text,
            date: date
        )
        } else {
            currentNote?.title = title
            currentNote?.text = text
            currentNote?.date = date
        }
        checkEmptyNote(currentNote)
    }

    @objc func dataChanged() {
        dateTextField.text = getDataToString(datePicker.date)
    }
}
// MARK: - SetConstraints
extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bodyContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bodyContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bodyContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(
                equalTo: bodyContainer.topAnchor,
                constant: ConstraintConstants.titleTextFieldTopAnchor
            ),
            titleTextField.leadingAnchor.constraint(
                equalTo: bodyContainer.leadingAnchor,
                constant: ConstraintConstants.titleTextFieldLeadingAnchor
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: bodyContainer.trailingAnchor,
                constant: ConstraintConstants.titleTextFieldTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor,
                constant: ConstraintConstants.dataPickerTopAnchor
            ),
            dateTextField.leadingAnchor.constraint(
                equalTo: bodyContainer.leadingAnchor,
                constant: ConstraintConstants.dataPickerLeadingAnchor
            ),
            dateTextField.trailingAnchor.constraint(
                equalTo: bodyContainer.trailingAnchor,
                constant: ConstraintConstants.dataPickerTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(
                equalTo: dateTextField.bottomAnchor,
                constant: ConstraintConstants.noteTextViewTopAnchor
            ),
            noteTextView.bottomAnchor.constraint(
                equalTo: bodyContainer.bottomAnchor,
                constant: ConstraintConstants.noteTextViewBottomAnchor
            ),
            noteTextView.leadingAnchor.constraint(
                equalTo: bodyContainer.leadingAnchor,
                constant: ConstraintConstants.noteTextViewLeadingAnchor
            ),
            noteTextView.trailingAnchor.constraint(
                equalTo: bodyContainer.trailingAnchor,
                constant: ConstraintConstants.noteTextViewTrailingAnchor
            )
        ])
    }
}
// MARK: - Constraint constants
extension MainViewController {
    private enum ConstraintConstants {
        static let titleTextFieldTopAnchor: CGFloat = 5
        static let titleTextFieldLeadingAnchor: CGFloat = 5
        static let titleTextFieldTrailingAnchor: CGFloat = -5
        static let dataPickerTopAnchor: CGFloat = 10
        static let dataPickerLeadingAnchor: CGFloat = 10
        static let dataPickerTrailingAnchor: CGFloat = -5
        static let noteTextViewTopAnchor: CGFloat = 10
        static let noteTextViewBottomAnchor: CGFloat = -5
        static let noteTextViewLeadingAnchor: CGFloat = 5
        static let noteTextViewTrailingAnchor: CGFloat = -5
    }
}
// MARK: - String constants
extension MainViewController {
    private enum StringConstants {
        // String constants
        static let titleTextFieldPlaceholder = "Введите заголовок"
        static let doneButtonNavigationBarTitle = "Готово"
        // Font constants
        static let titleTextFieldFontSize: CGFloat = 22.0
        static let dateTextFieldFontSize: CGFloat = 14.0
        static let noteTextViewFontSize: CGFloat = 14.0
    }
}
// MARK: - Private Methods
extension MainViewController {
    private func configureUI() {
        setupViews()
        setNavigationBar()
        setConstraints()
        setupDelegate()
        if let note = storage.loadDate(key: "note") {
            currentNote = note
            if !(currentNote!.isEmpty) {
                titleTextField.text = note.title
                dateTextField.text = getDataToString(note.date)
                noteTextView.text = note.text
            }
        } else {
            titleTextField.text = nil
            dateTextField.text = nil
            noteTextView.text = nil
        }
        datePicker.addTarget(self, action: #selector(dataChanged), for: .valueChanged)
        dateTextField.placeholder = getDataToString(Date())
        dateTextField.inputView = datePicker
        noteTextView.becomeFirstResponder()
    }

    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { _ in
            if self.currentNote != nil {
                if !self.currentNote!.isEmpty {
                    self.storage.save(note: self.currentNote!, key: "note")
                }
            }
        }
    }

    private func removeDidEnterBackgroundNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    private func setNavigationBar() {
        let doneButtonNavigationBar: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setTitle(StringConstants.doneButtonNavigationBarTitle, for: .normal)
            button.addTarget(self, action: #selector(checkNoteAndHideKeyboard), for: .touchUpInside)
            let menuBarItem = UIBarButtonItem(customView: button)
            return menuBarItem
        }()
        navigationItem.rightBarButtonItem = doneButtonNavigationBar
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(bodyContainer)
        bodyContainer.addSubview(titleTextField)
        bodyContainer.addSubview(dateTextField)
        bodyContainer.addSubview(noteTextView)
    }

    private func setupDelegate() {
        self.titleTextField.delegate = self
        self.noteTextView.delegate = self
    }

    private func getDataToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "Дата: dd MMMM yyyy"
        return formatter.string(from: date)
    }

    private func checkEmptyNote(_ note: NoteProtocol?) {
        if note != nil {
            if note!.isEmpty {
                // Create a new alert
                let dialogMessage = UIAlertController(
                    title: "Предупреждение",
                    message: "Оба поля заметки не могут быть пустыми",
                    preferredStyle: .alert
                )

                // Create OK button with action handler
                let okButton = UIAlertAction(title: "OK", style: .default)

                // Add OK button to a dialog message
                dialogMessage.addAction(okButton)
                // Present alert to user
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
    }
}
