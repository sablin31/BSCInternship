//
//  NoteCellTableViewCell.swift
//  BSCInternship
//
//  Created by Алексей Саблин on 19.04.2022.
//

import UIKit

class NoteCell: UITableViewCell {
    // MARK: - Properties

    static let reuseId = String(describing: NoteCell.self)
    var note: Note?
    // MARK: - UI Properties

    private let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleLabelTextFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let txtLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.txtLabelTextColor
        label.font = Constants.txtLabelTextFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.dateLabelTextFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureСell()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Inheritance

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
        txtLabel.text = nil
        titleLabel.text = note?.title ?? " "
        dateLabel.text = note?.date.toString(dateFormat: Constants.dateFormat)
        txtLabel.text = note?.text
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateColorUI()
    }
    // MARK: - Public methods

    func set(with note: Note?) {
        self.note = note
        updateData()
    }
}
// MARK: - Private methods

private extension NoteCell {
    func configureСell() {
        bgView.layer.borderWidth = Constants.viewBorderWidth
        bgView.layer.cornerRadius = Constants.viewCornerRadius
        backgroundColor = .clear
        backgroundView = bgView
        let selectedBGView = UIView()
        selectedBackgroundView = selectedBGView
        selectedBGView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(txtLabel)
        contentView.addSubview(dateLabel)
        contentView.backgroundColor = .clear
        clipsToBounds = true
        updateColorUI()
    }

    func updateData() {
        titleLabel.text = note?.title ?? " "
        dateLabel.text = note?.date.toString(dateFormat: Constants.dateFormat)
        txtLabel.text = note?.text
    }

    func updateColorUI() {
        if traitCollection.userInterfaceStyle == .dark {
            bgView.layer.borderColor = Constants.backgroundColorDark.cgColor
            bgView.layer.backgroundColor = Constants.viewBgColorDark.cgColor
            titleLabel.textColor = Constants.titleLabelTextColorDark
            dateLabel.textColor = Constants.dateLabelTextColorDark
        } else {
            bgView.layer.borderColor = Constants.backgroundColorLight.cgColor
            bgView.layer.backgroundColor = Constants.viewBgColorLight.cgColor
            titleLabel.textColor = Constants.titleLabelTextColorLight
            dateLabel.textColor = Constants.dateLabelTextColorLight
        }
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.titleLabelTopAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.titleLabelLeadingAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Constants.titleLabelTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            txtLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.txtLabelTopAnchor
            ),
            txtLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.txtLabelLeadingAnchor
            ),
            txtLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Constants.txtLabelTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.dateLabelLeadingAnchor
            ),
            dateLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Constants.dateLabelTrailingAnchor
            ),
            dateLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Constants.dateLabelTopBottom
            )
        ])
    }
}
// MARK: - Constants

extension NoteCell {
    private enum Constants {
        // MARK: Constraint constant

        static let titleLabelTopAnchor: CGFloat = 10
        static let titleLabelLeadingAnchor: CGFloat = 16
        static let titleLabelTrailingAnchor: CGFloat = -16

        static let txtLabelTopAnchor: CGFloat = 4
        static let txtLabelLeadingAnchor: CGFloat = 16
        static let txtLabelTrailingAnchor: CGFloat = -16

        static let dateLabelLeadingAnchor: CGFloat = 16
        static let dateLabelTrailingAnchor: CGFloat = 274
        static let dateLabelTopBottom: CGFloat = -10

        // MARK: UI Constant properties

        static let backgroundColorLight = UIColor(red: 0.976, green: 0.98, blue: 0.996, alpha: 1)
        static let backgroundColorDark = UIColor.darkGray

        static let viewBgColorLight = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        static let viewBgColorDark = UIColor.black

        static let viewCornerRadius: CGFloat = 14
        static let viewBorderWidth: CGFloat = 2

        static let titleLabelTextColorLight = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let titleLabelTextColorDark = UIColor.white
        static let titleLabelTextFont = UIFont(name: "SFProText-Medium", size: 16)

        static let txtLabelTextColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
        static let txtLabelTextFont = UIFont(name: "SFProText-Medium", size: 10)

        static let dateLabelTextColorLight = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        static let dateLabelTextColorDark = UIColor.white
        static let dateLabelTextFont = UIFont(name: "SFProText-Medium", size: 10)

        // MARK: String constants

        static let dateFormat = "dd.MM.yyyy"
    }
}
