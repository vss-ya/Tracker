//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by vs on 05.04.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let control = UISwitch()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.onTintColor = UIColor.ypBlue
        control.addTarget(self, action: #selector(self.onSwitchAction), for: .valueChanged)
        return control
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGray
        return view
    }()
    
    var titleText: String? { didSet { configure() } }
    var isOn: Bool = false { didSet { configure() } }
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
        
        addSubview(titleLabel)
        addSubview(switchControl)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    @objc private func onSwitchAction() {
        onSwitchCallback?(switchControl.isOn)
    }
    
    private func configure() {
        titleLabel.text = titleText
        switchControl.isOn = isOn
        separatorView.isHidden = isSeparatorViewHidden
    }
    
}
