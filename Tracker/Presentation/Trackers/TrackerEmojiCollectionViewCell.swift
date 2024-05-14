//
//  TrackerEmojiCollectionViewCell.swift
//  Tracker
//
//  Created by vs on 19.04.2024.
//

import UIKit

final class TrackerEmojiCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier = "TrackerEmojiCollectionViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    var emoji: String? { didSet { configure() } }
    override var isSelected: Bool { didSet { configure() } }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configure() {
        emojiLabel.text = emoji
        if isSelected {
            backgroundColor = .ypLightGray
        } else {
            backgroundColor = .ypWhite
        }
    }
    
}
