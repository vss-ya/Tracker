//
//  StatisticViewController.swift
//  Tracker
//
//  Created by vs on 04.04.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var emptyStatImageView: UIImageView = { createEmptyStatImageView() }()
    private lazy var emptyStatLabel: UILabel = { createEmptyStatLabel() }()
    private lazy var tableView: UITableView = { createTableView() }()
    
    private let calendar: Calendar = Calendar.current
    private let stats = Stat.allCases
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var trackers: [Tracker] = []
    private var completedTrackers: [TrackerRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(headerLabel)
        view.addSubview(emptyStatImageView)
        view.addSubview(emptyStatLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyStatImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 246),
            emptyStatImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyStatImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStatLabel.centerXAnchor.constraint(equalTo: emptyStatImageView.centerXAnchor),
            emptyStatLabel.topAnchor.constraint(equalTo: emptyStatImageView.bottomAnchor, constant: 8),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 77),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    private func addSubviews() {
        view.addSubview(headerLabel)
        view.addSubview(emptyStatImageView)
        view.addSubview(emptyStatLabel)
        view.addSubview(tableView)
    }
    
    private func loadData() {
        trackers = trackerStore.trackers
        completedTrackers = trackerRecordStore.trackerRecords
        updateScreen()
    }
    
    private func updateScreen() {
        let isEmpty = trackers.isEmpty && completedTrackers.isEmpty
        
        emptyStatImageView.isHidden = !isEmpty
        emptyStatLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    func onlyDate(_ date: Date) -> Date {
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: dateComponents)!
    }
    
    func calcBestPeriod() -> Int {
        return 0
    }
    
    func calcIdealDays() -> Int {
        return 0
    }
    
    func calcCompletedTrackers() -> Int {
        return completedTrackers.count
    }
    
    func calcAverageValue() -> Int {
        return 0
    }
    
}

// MARK: - Factory
extension StatisticViewController {
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = L10n.statistic
        return label
    }
    
    private func createEmptyStatImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EmptyStat")
        return imageView
    }
    
    private func createEmptyStatLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = L10n.emptyStatText
        return label
    }
    
    private func createTableView() -> UITableView {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .ypWhite
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(StatisticTableViewCell.self,
                      forCellReuseIdentifier: StatisticTableViewCell.reuseIdentifier)
        return view
    }
    
}

// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticTableViewCell
        guard let cell else {
            return UITableViewCell()
        }
        
        let stat = stats[indexPath.row]
        let count = switch stat {
        case .bestPeriod:
            calcBestPeriod()
        case .idealDays:
            calcIdealDays()
        case .completedTrackers:
            calcCompletedTrackers()
        case .averageValue:
            calcAverageValue()
        }
        
        cell.update(title: stat.description, count: count)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
}
