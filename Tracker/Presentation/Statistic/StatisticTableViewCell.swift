//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by vs on 29.05.2024.
//

import UIKit

final class StatisticTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "StatisticTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let outerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlue
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let innerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = ["#007BFA", "#46E69D", "#FD4C49"].reversed().map({
            UIColor(hex: $0).cgColor
        })
        layer.locations = [0, 0.5, 1]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = 16
        return layer
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        clipsToBounds = true
        
        selectionStyle = .none
        isUserInteractionEnabled = false
        
        addSubview(outerView)
        addSubview(innerView)
        addSubview(countLabel)
        addSubview(titleLabel)
        outerView.layer.addSublayer(gradientLayer)
        
        NSLayoutConstraint.activate([
            outerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            outerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerView.heightAnchor.constraint(equalToConstant: 90),
            innerView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 1),
            innerView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -1),
            innerView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 1),
            innerView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -1),
            countLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = outerView.bounds
    }
    
    func update(title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = "\(count)"
    }
    
}
