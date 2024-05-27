//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by vs on 05.04.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerCollectionViewCell"
    
    private lazy var cardView: UIView = { createCardView() }()
    private lazy var emojiBackgroundView: UIView = { createEmojiBackgroundView() }()
    private lazy var emojiLabel: UILabel = { creatEmojiLabel() }()
    private lazy var descriptionLabel: UILabel = { createDescriptionLabel() }()
    private lazy var completedDaysLabel: UILabel = { createCompletedDaysLabel() }()
    private lazy var completeButton: UIButton = { createCompleteButton() }()
    
    private let doneImage = UIImage(named: "Done")
    private let plusImage = UIImage(named: "Plus")
    
    private var completeCallback: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        completeCallback = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
}

// MARK: - Actions
extension TrackerCollectionViewCell {
    
    @objc private func addAction() {
        completeCallback?()
    }
    
}

// MARK: - Helpers
extension TrackerCollectionViewCell {
    
    func setup() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(cardView)
        contentView.addSubview(emojiBackgroundView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(completedDaysLabel)
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            completedDaysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            completedDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            completeButton.centerYAnchor.constraint(equalTo: completedDaysLabel.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
        ])
    }
    
    func configure(tracker: Tracker, completedDays: Int, isCompleted: Bool, onComplete: @escaping (() -> Void)) {
        cardView.backgroundColor = tracker.color
        descriptionLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        completedDaysLabel.text = formatDays(completedDays)
        completeCallback = onComplete
        
        let image = (isCompleted ? doneImage : plusImage)?.withTintColor(tracker.color)
        completeButton.setImage(image, for: .normal)
    }
    
    private func formatDays(_ completedDays: Int) -> String {
        return "numberOfDays".localized(arguments: completedDays)
    }
    
}

// MARK: - Factory
extension TrackerCollectionViewCell {
    
    private func createCardView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0,
                            y: 0,
                            width: contentView.frame.width,
                            height: contentView.frame.width * 0.55)
        view.layer.cornerRadius = 16
        return view
    }
    
    private func createEmojiBackgroundView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 12, y: 12, width: 24, height: 24)
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.opacity = 0.3
        return view
    }
    
    private func creatEmojiLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }
    
    private func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 120, y: 106, width: 143, height: 34)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhite
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = 143
        return label
    }
    
    private func createCompletedDaysLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 120, y: 106, width: 101, height: 18)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }
    
    private func createCompleteButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 100, y: 100, width: 34, height: 34)
        button.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return button
    }
    
}
