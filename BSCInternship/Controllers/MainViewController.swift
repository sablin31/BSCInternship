//
//  MainViewController.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 27.03.2022.
//

import UIKit

import UIKit

class MainViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    private let storage = DataStorage()
    
    private let doneButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }()
    
    private let bodyContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: NumberConstants.titleTextFieldFontSize, weight: UIFont.Weight.bold)
        textField.borderStyle = .none
        textField.placeholder = "Введите заголовок"
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nodeTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: NumberConstants.nodeTextViewFontSize, weight: UIFont.Weight.regular)
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    deinit {
        removeDidEnterBackgroundNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setNavigationBar()
        setConstraints()
        setupDelegate()
        registerDidEnterBackgroundNotification()
        titleTextField.text = storage.load(key: "title")
        nodeTextView.text = storage.load(key: "node")
        nodeTextView.becomeFirstResponder()
    }
    
    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
            self.storage.save(data: self.titleTextField.text ?? "", key: "title")
            self.storage.save(data: self.nodeTextView.text ?? "", key: "node")
        }
    }
    
    private func removeDidEnterBackgroundNotification(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(bodyContainer)
        bodyContainer.addSubview(titleTextField)
        bodyContainer.addSubview(nodeTextView)
    }
    
    private func setupDelegate() {
        self.titleTextField.delegate = self
        self.nodeTextView.delegate = self
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - SetConstraints
extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bodyContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bodyContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bodyContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: bodyContainer.topAnchor, constant: NumberConstants.titleTextFieldTopAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: bodyContainer.leadingAnchor, constant: NumberConstants.titleTextFieldLeadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: bodyContainer.trailingAnchor,constant: NumberConstants.titleTextFieldTrailingAnchor)
        ])
            
        NSLayoutConstraint.activate([
            nodeTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: NumberConstants.nodeTextViewTopAnchor),
            nodeTextView.bottomAnchor.constraint(equalTo: bodyContainer.bottomAnchor, constant: NumberConstants.nodeTextViewBottomAnchor),
            nodeTextView.leadingAnchor.constraint(equalTo: bodyContainer.leadingAnchor, constant: NumberConstants.nodeTextViewLeadingAnchor),
            nodeTextView.trailingAnchor.constraint(equalTo: bodyContainer.trailingAnchor, constant: NumberConstants.nodeTextViewTrailingAnchor)
        ])
    }
    //MARK: - NumberConstants
    private struct NumberConstants {
        // Constraint constant
        static let titleTextFieldTopAnchor: CGFloat = 5
        static let titleTextFieldLeadingAnchor: CGFloat = 5
        static let titleTextFieldTrailingAnchor: CGFloat = -10
        static let nodeTextViewTopAnchor: CGFloat = 5
        static let nodeTextViewBottomAnchor: CGFloat = -5
        static let nodeTextViewLeadingAnchor: CGFloat = 5
        static let nodeTextViewTrailingAnchor: CGFloat = -5
        // Font constant
        static let titleTextFieldFontSize: CGFloat = 22.0
        static let nodeTextViewFontSize: CGFloat = 14.0
    }
}

