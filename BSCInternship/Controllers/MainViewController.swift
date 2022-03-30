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

    private let bodyContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: Constants.titleTextFieldFontSize, weight: UIFont.Weight.bold)
        textField.borderStyle = .none
        textField.placeholder = Constants.titleTextFieldPlaceholder
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: Constants.noteTextViewFontSize, weight: UIFont.Weight.regular)
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

    @objc func hideKeyboard() {
        view.endEditing(true)
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
                constant: Constants.titleTextFieldTopAnchor
            ),
            titleTextField.leadingAnchor.constraint(
                equalTo: bodyContainer.leadingAnchor,
                constant: Constants.titleTextFieldLeadingAnchor
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: bodyContainer.trailingAnchor,
                constant: Constants.titleTextFieldTrailingAnchor
            )
        ])
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor,
                constant: Constants.noteTextViewTopAnchor
            ),
            noteTextView.bottomAnchor.constraint(
                equalTo: bodyContainer.bottomAnchor,
                constant: Constants.noteTextViewBottomAnchor
            ),
            noteTextView.leadingAnchor.constraint(
                equalTo: bodyContainer.leadingAnchor,
                constant: Constants.noteTextViewLeadingAnchor
            ),
            noteTextView.trailingAnchor.constraint(
                equalTo: bodyContainer.trailingAnchor,
                constant: Constants.noteTextViewTrailingAnchor
            )
        ])
    }
}
// MARK: - Constants
extension MainViewController {
    private enum Constants {
        // Constraint constants
        static let titleTextFieldTopAnchor: CGFloat = 5
        static let titleTextFieldLeadingAnchor: CGFloat = 5
        static let titleTextFieldTrailingAnchor: CGFloat = -10
        static let noteTextViewTopAnchor: CGFloat = 5
        static let noteTextViewBottomAnchor: CGFloat = -5
        static let noteTextViewLeadingAnchor: CGFloat = 5
        static let noteTextViewTrailingAnchor: CGFloat = -5
        // Font constants
        static let titleTextFieldFontSize: CGFloat = 22.0
        static let noteTextViewFontSize: CGFloat = 14.0
        // String constants
        static let titleTextFieldPlaceholder = "Введите заголовок"
        static let doneButtonTitle = "Готово"
        static let titleKeyNameStorage = "title"
        static let noteKeyNameStorage = "note"
    }
}
// MARK: - Private Methods
extension MainViewController {
    private func configureUI() {
        setupViews()
        setNavigationBar()
        setConstraints()
        setupDelegate()
        titleTextField.text = storage.load(key: Constants.titleKeyNameStorage)
        noteTextView.text = storage.load(key: Constants.noteKeyNameStorage)
        noteTextView.becomeFirstResponder()
    }

    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { _ in
            if self.titleTextField.text != nil {
                self.storage.save(data: self.titleTextField.text!, key: Constants.titleKeyNameStorage)
            }
            if self.noteTextView.text != nil {
                self.storage.save(data: self.noteTextView.text!, key: Constants.noteKeyNameStorage)
            }
        }
    }

    private func removeDidEnterBackgroundNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    private func setNavigationBar() {
        let doneButton: UIBarButtonItem = {
            let button = UIButton(type: .system)
            button.setTitle(Constants.doneButtonTitle, for: .normal)
            button.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
            let menuBarItem = UIBarButtonItem(customView: button)
            return menuBarItem
        }()
        navigationItem.rightBarButtonItem = doneButton
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(bodyContainer)
        bodyContainer.addSubview(titleTextField)
        bodyContainer.addSubview(noteTextView)
    }

    private func setupDelegate() {
        self.titleTextField.delegate = self
        self.noteTextView.delegate = self
    }
}
