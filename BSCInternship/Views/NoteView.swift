//
//  NoteCard.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 09.04.2022.
//

import UIKit

class NoteView: UIView {
    // MARK: - Properties

    var note: Note?
    // MARK: - UI Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.titleLabelTextColor
        label.font = Constants.titleLabelTextFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.textLabelTextColor
        label.font = Constants.textLabelTextFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.dateLabelTextColor
        label.font = Constants.dateLabelTextFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Init

    init() {
        super.init(frame: .zero)
        self.configureView()
        self.setConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public methods

    func set(with note: Note?) {
        self.note = note
        updateView()
    }
}
// MARK: - Private methods

extension NoteView {
    private func configureView() {
        self.layer.backgroundColor = Constants.viewBgColor
        self.layer.cornerRadius = Constants.viewCornerRadius
        self.addSubview(titleLabel)
        self.addSubview(textLabel)
        self.addSubview(dateLabel)
    }

    func updateView() {
        self.titleLabel.text = note?.title ?? " "
        self.dateLabel.text = note?.date.toString(dateFormat: Constants.dateFormat)
        self.textLabel.text = note?.text
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Constants.textLabelTopAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constants.titleLabelLeadingAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constants.titleLabelTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.textLabelTopAnchor
            ),
            textLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constants.textLabelLeadingAnchor
            ),
            textLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constants.textLabelTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constants.dateLabelLeadingAnchor
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constants.dateLabelTrailingAnchor
            ),
            dateLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: Constants.dateLabelTopBottom
            )
        ])
    }
}
// MARK: - Constants

extension NoteView {
    private enum Constants {
        // MARK: Constraint constant

        static let titleLabelTopAnchor: CGFloat = 10
        static let titleLabelLeadingAnchor: CGFloat = 16
        static let titleLabelTrailingAnchor: CGFloat = -16

        static let textLabelTopAnchor: CGFloat = 4
        static let textLabelLeadingAnchor: CGFloat = 16
        static let textLabelTrailingAnchor: CGFloat = -16

        static let dateLabelLeadingAnchor: CGFloat = 16
        static let dateLabelTrailingAnchor: CGFloat = 274
        static let dateLabelTopBottom: CGFloat = -10

        // MARK: UI Constant properties

        static let viewBgColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        static let viewCornerRadius: CGFloat = 14

        static let titleLabelTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let titleLabelTextFont = UIFont(name: "SFProText-Medium", size: 16)

        static let textLabelTextColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
        static let textLabelTextFont = UIFont(name: "SFProText-Medium", size: 10)

        static let dateLabelTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let dateLabelTextFont = UIFont(name: "SFProText-Medium", size: 10)

        // MARK: String constants

        static let dateFormat = "dd.MM.yyyy"
    }
}
