//
//  ViewController+Extension.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 17.04.2022.
//

import UIKit

// MARK: - Keyboard show/hide notification

extension UIViewController {
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {}

    @objc func keyboardWillHide(notification: Notification) {}
}
// MARK: - Ok Alert show

extension UIViewController {
    func showAlert(titleMessage: String, message: String, titleButton: String) {
        let dialogMessage = UIAlertController(
            title: titleMessage,
            message: message,
            preferredStyle: .alert
        )

        let okButton = UIAlertAction(
            title: titleButton,
            style: .default
        )

        dialogMessage.addAction(okButton)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
