//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by vs on 05.04.2024.
//

import UIKit

final class AddTrackerViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var habitButton: UIButton = { createHabitButton() }()
    private lazy var irregularEventButton: UIButton = { createIrregularEventButton() }()
    
    var onCreateTrackerCallback: ((Tracker)->(Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    private func prepare() {
        view.backgroundColor = .white
        
        view.addSubview(headerLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 295),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.text = "Создание трекера"
        return label
    }
    
    private func createHabitButton() -> UIButton {
        return createButton(title: "Привычка", action: #selector(habitAction))
    }
    
    private func createIrregularEventButton() -> UIButton {
        return createButton(title: "Нерегулярное событие", action: #selector(irregularEventAction))
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.backgroundColor = .ypBlack
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }
    
}

// MARK: - Actions
extension AddTrackerViewController {
    
    @objc private func habitAction() {
        let vc = HabitViewController()
        vc.onCreateTrackerCallback = { [weak self] in
            guard let self else {
                return
            }
            onCreateTrackerCallback?($0)
            dismiss(animated: true, completion: nil)
        }
        present(vc, animated: true)
    }
    
    @objc private func irregularEventAction() {
        let vc = IrregularEventViewController()
        vc.onCreateTrackerCallback = { [weak self] in
            guard let self else {
                return
            }
            onCreateTrackerCallback?($0)
            dismiss(animated: true, completion: nil)
        }
        present(vc, animated: true)
    }
    
}