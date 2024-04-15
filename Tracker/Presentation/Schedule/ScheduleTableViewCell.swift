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
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = UIColor.ypBlue
        switchControl.addTarget(self, action: #selector(self.onSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    var onSwitchCallback: ((Bool) -> (Void))?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateLabel(title: String) {
        titleLabel.text = title
    }
    
    func updateSwitchControl(isOn: Bool) {
        switchControl.isOn = isOn
    }
    
    @objc private func onSwitchAction() {
        onSwitchCallback?(switchControl.isOn)
    }
    
}
