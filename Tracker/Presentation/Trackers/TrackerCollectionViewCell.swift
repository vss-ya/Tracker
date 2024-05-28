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
    private lazy var pinImageView: UIImageView = { createPinImageView() }()
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let size = emojiBackgroundView.frame.size
        emojiBackgroundView.layer.cornerRadius = size.width / 2
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
    
    func configure(tracker: Tracker) {
        cardView.backgroundColor = tracker.color
        descriptionLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        pinImageView.isHidden = !tracker.pinned
    }
    
    func configure(tracker: Tracker, completedDays: Int, isCompleted: Bool, onComplete: @escaping (() -> Void)) {
        configure(tracker: tracker)
        
        completedDaysLabel.text = formatDays(completedDays)
        completeCallback = onComplete
        
        let image = (isCompleted ? doneImage : plusImage)?.withTintColor(tracker.color)
        completeButton.setImage(image, for: .normal)
    }
    
    func configurePreview(tracker: Tracker) {
        configure(tracker: tracker)
        
        layer.cornerRadius = 0
        cardView.layer.cornerRadius = 0
        completedDaysLabel.isHidden = true
        completeButton.isHidden = true
    }
    
    private func setup() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        contentView.addSubview(cardView)
        contentView.addSubview(emojiBackgroundView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(pinImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(completedDaysLabel)
        contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.55),
            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalTo: emojiBackgroundView.widthAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            pinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            pinImageView.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            completedDaysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            completedDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            completeButton.centerYAnchor.constraint(equalTo: completedDaysLabel.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
        ])
    }
    
    private func formatDays(_ completedDays: Int) -> String {
        return "numberOfDays".localized(arguments: completedDays)
    }
    
}

// MARK: - Factory
extension TrackerCollectionViewCell {
    
    private func createCardView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }
    
    private func createEmojiBackgroundView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        view.layer.opacity = 0.3
        return view
    }
    
    private func creatEmojiLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }
    
    private func createPinImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Pin")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypAnyWhite
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = 143
        return label
    }
    
    private func createCompletedDaysLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }
    
    private func createCompleteButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return button
    }
    
}
