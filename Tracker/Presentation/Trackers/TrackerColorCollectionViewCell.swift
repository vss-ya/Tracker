//
//  TrackerColorCollectionViewCell.swift
//  Tracker
//
//  Created by vs on 19.04.2024.
//

import UIKit

final class TrackerColorCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerColorCollectionViewCell"
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    var color: UIColor? { didSet { configure() } }
    override var isSelected: Bool { didSet { configure() } }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        contentView.addSubview(colorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        colorView.frame = CGRect(x: (contentView.bounds.width - 40) / 2,
                                 y: (contentView.bounds.height - 40) / 2,
                                 width: 40,
                                 height: 40)
    }
    
    private func configure() {
        colorView.backgroundColor = color
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = color?.withAlphaComponent(0.3).cgColor
        } else {
            layer.borderWidth = 0
        }
    }
    
}
