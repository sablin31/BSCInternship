//
//  UIImageView+Extension.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 26.05.2022.
//

import UIKit

// MARK: - Set image to UIImageView for URL

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else { return }

        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
