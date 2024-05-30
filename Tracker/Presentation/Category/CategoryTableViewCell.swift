//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by vs on 14.05.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let checkImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .categoryCheck
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
    var isChecked: Bool = false { didSet { configure() } }
    var isSeparatorViewHidden: Bool = false { didSet { configure() } }
    var onSwitchCallback: ((Bool) -> (Void))?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypBackgroundGray
        clipsToBounds = true
        layer.cornerRadius = 16
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkImage)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    private func configure() {
        titleLabel.text = titleText
        checkImage.isHidden = !isChecked
        separatorView.isHidden = isSeparatorViewHidden
    }
    
}
