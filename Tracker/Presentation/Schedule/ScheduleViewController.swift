//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by vs on 05.04.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var tableView: UITableView = { createTableView() }()
    private lazy var doneButton: UIButton = { createDoneButton() }()
    
    private var weekDays: [WeekDay] = WeekDay.allCases
    private lazy var selectedWeekDays: [Bool] = [Bool](repeating: false, count: weekDays.count)
    
    var onDoneCallback: (([WeekDay])->(Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

// MARK: - Actions
extension ScheduleViewController {
    
    @objc private func doneAction() {
        var result: [WeekDay] = []
        for (index, val) in selectedWeekDays.enumerated() where val == true {
            result.append(weekDays[index])
        }
        onDoneCallback?(result)
    }
    
}

// MARK: - Helpers
extension ScheduleViewController {
    
    func setSelectedWeekDays(_ days: [WeekDay]) {
        for day in days {
            guard let index = weekDays.firstIndex(of: day) else {
                continue
            }
            selectedWeekDays[index] = true
        }
        if isViewLoaded {
            tableView.reloadData()
        }
    }
    
    private func setup() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configure(_ cell: ScheduleTableViewCell, at indexPath: IndexPath) {
        let weekDay = weekDays[indexPath.row]
        let title = "\(weekDay.name)"
        let isOn = selectedWeekDays[indexPath.row]
        
        cell.selectionStyle = .none
        cell.titleText = title
        cell.isOn = isOn
        cell.onSwitchCallback = { [weak self] in
            guard let self else {
                return
            }
            selectedWeekDays[indexPath.row] = $0
        }
    }
    
}

// MARK: - Factory
extension ScheduleViewController {
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypBackgroundGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleTableViewCell.self,
                           forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        return tableView
    }
    
    private func createDoneButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.backgroundColor = .ypBlack
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.setTitle("Готово", for: .normal)
        btn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return btn
    }
    
    private func createSeparatorViewForCell(_ cell: UITableViewCell) -> UIView {
        let inset = 16.0
        let width = tableView.bounds.width - inset * 2
        let height = 1.0
        let x = inset
        let y = cell.frame.height - height
        let view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        view.backgroundColor = .ypGray
        return view
    }
    
}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.addSubview(createSeparatorViewForCell(cell))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ScheduleTableViewCell
        guard let cell else {
            return UITableViewCell()
        }
        configure(cell, at: indexPath)
        return cell
    }
    
}
