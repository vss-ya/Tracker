//
//  TrackerOptionTableViewCell.swift
//  Tracker
//
//  Created by vs on 15.04.2024.
//

import UIKit

final class TrackerOptionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TrackerOptionTableViewCell"
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(descriptionLabel)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let chevronImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Chevron")
        image.tintColor = .ypGray
        return image
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGray
        return view
    }()
    
    var titleText: String? { didSet { configure() } }
    var descriptionText: String? { didSet { configure() } }
    var isSeparatorViewHidden: Bool = false { didSet { configure() } }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypBackgroundGray
        clipsToBounds = true
        layer.cornerRadius = 16
        
        addSubview(stackView)
        addSubview(chevronImage)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImage.widthAnchor.constraint(equalToConstant: 24),
            chevronImage.heightAnchor.constraint(equalToConstant: 24),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    private func configure() {
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        separatorView.isHidden = isSeparatorViewHidden
    }
    
}

