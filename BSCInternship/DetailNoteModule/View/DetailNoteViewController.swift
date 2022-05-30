//
//  DetailNoteViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import UIKit

class DetailNoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // MARK: - Proterties

    var presenter: DetailNotePresenterProtocol?
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
        textView.backgroundColor = .clear
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

    deinit { removeKeyboardNotification() }
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerKeyboardNotification()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                changeColorUI(to: traitCollection.userInterfaceStyle)
            }
        }
    }

    @objc override func keyboardWillShow(notification: Notification) {
        setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = doneButtonNavigationBar
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = noteTextView.convert(keyboardScreenEndFrame, from: noteTextView.window)

        noteTextView.contentInset = UIEdgeInsets(
            top: Constants.noteTextViewContentInsetTop,
            left: Constants.noteTextViewContentInsetLeft,
            bottom: keyboardViewEndFrame.height - noteTextView.safeAreaInsets.bottom,
            right: Constants.noteTextViewContentInsetRight
        )
    }

    @objc override func keyboardWillHide(notification: Notification) {
        setEditing(false, animated: true)
        noteTextView.contentInset = .zero
        let newPosition = noteTextView.beginningOfDocument
        noteTextView.selectedTextRange = noteTextView.textRange(from: newPosition, to: newPosition)
        navigationItem.rightBarButtonItem = nil
    }

    // MARK: - Actions methods

    @objc func leftBarButtonAction() {
        let title = (titleTextField.text?.isEmpty ?? true) ? nil : titleTextField.text
        let text = (noteTextView.text?.isEmpty ?? true) ? nil : noteTextView.text
        if (title != nil || text != nil) && isEditing {
            presenter?.updateNote(title: title, text: text)
        }
        presenter?.returnToListNotes()
    }

    @objc func rightBarButtonAction() {
        view.endEditing(true)
        let title = (titleTextField.text?.isEmpty ?? true) ? nil : titleTextField.text
        let text = (noteTextView.text?.isEmpty ?? true) ? nil : noteTextView.text
        if title == nil, text == nil {
            showAlert(
                titleMessage: Constants.titleAlert,
                message: Constants.messageAlert,
                titleButton: Constants.titleOkButtonAlert
            )
        } else {
            presenter?.updateNote(title: title, text: text)
            dateLabel.text = presenter?.note?.date.toString(dateFormat: Constants.dateFormat)
        }
    }
}
// MARK: - Private Methods

private extension DetailNoteViewController {
    func configureUI() {
        setupViews()
        changeColorUI(to: traitCollection.userInterfaceStyle)
        setNavigationBar()
        setConstraints()
        setupDelegate()

        dateLabel.text = presenter?.note?.date.toString(
            dateFormat: Constants.dateFormat
        ) ?? Date().toString(
            dateFormat: Constants.dateFormat
        )
        titleTextField.text = presenter?.note?.title
        noteTextView.text = presenter?.note?.text

        titleTextField.autocorrectionType = .no
        noteTextView.autocorrectionType = .no
        if self.presenter?.note == nil { noteTextView.becomeFirstResponder() }
    }

    func setNavigationBar() {
        navigationItem.leftBarButtonItem = backButtonNavigationBar
    }

    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        backgroundView.addSubview(dateLabel)
        backgroundView.addSubview(titleTextField)
        backgroundView.addSubview(scrollView)
        scrollView.addSubview(noteTextView)
    }

    func changeColorUI(to currentUserInterfaceStyle: UIUserInterfaceStyle) {
        if currentUserInterfaceStyle == .dark {
            view.backgroundColor = Constants.backgroundColorDark
            titleTextField.textColor = Constants.titleTextFieldColorDark
        } else {
            view.backgroundColor = Constants.backgroundColorLight
            titleTextField.textColor = Constants.titleTextFieldColorLight
        }
    }

    func setupDelegate() {
        titleTextField.delegate = self
        noteTextView.delegate = self
    }

    // MARK: Set constraint

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
                multiplier: Constants.scrollViewMultiplier,
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
}
// MARK: - DetailNoteViewProtocol methods

extension DetailNoteViewController: DetailNoteViewProtocol { }
// MARK: - Constants

extension DetailNoteViewController {
    private enum Constants {
        // MARK: UI Properties constants

        static let backgroundColorLight = UIColor(red: 0.976, green: 0.98, blue: 0.996, alpha: 1)
        static let backgroundColorDark = UIColor.darkGray

        static let backButtonNavigationBarImageSystemName = "chevron.backward"
        static let doneButtonNavigationBarTitle = "Готово"

        static let dateFormat = "dd.MM.yyyy EEEE HH:mm"

        static let dateLabelFrame = CGRect(x: 0, y: 0, width: 130, height: 22)
        static let dateLabelTextFont = UIFont(name: "SFProText-Medium", size: 16)
        static let dateLabelTextColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)

        static let titleTextFieldColorLight = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let titleTextFieldColorDark = UIColor.white
        static let titleTextFieldPlaceholder = "Введите название"
        static let titleTextFieldFont = UIFont(name: "SFProText-Medium", size: 24)

        static let noteTextViewFont = UIFont(name: "SFProText-Medium", size: 16)

        static let titleAlert = "Предупреждение"
        static let messageAlert = "Оба поля заметки не могут быть пустыми"
        static let titleOkButtonAlert = "OK"

        static let noteTextViewContentInsetTop: CGFloat = 0
        static let noteTextViewContentInsetLeft: CGFloat = 0
        static let noteTextViewContentInsetRight: CGFloat = 0

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
        static let scrollViewMultiplier: CGFloat = 1
    }
}
