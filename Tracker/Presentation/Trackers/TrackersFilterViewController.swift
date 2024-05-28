//
//  TrackersFilterViewController.swift
//  Tracker
//
//  Created by vs on 28.05.2024.
//

import UIKit

final class TrackersFilterViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var tableView: UITableView = { createTableView() }()
    
    private let filters: [Filter] = Filter.allCases
    private var selectedFilter: Filter = .allTrackers
    
    private var onDidSelectCallback: ((Filter)->(Void))?
    
    convenience init(selectedFilter: Filter, onDidSelect onDidSelectCallback: ( (Filter) -> Void)? = nil) {
        self.init()
        self.selectedFilter = selectedFilter
        self.onDidSelectCallback = onDidSelectCallback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

// MARK: - Helpers
extension TrackersFilterViewController {
    
    func setSelectedFilter(_ filter: Filter) {
        selectedFilter = filter
    }
    
    private func setup() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    private func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        let title = "\(filter.description)"
        let isChecked = (filter == selectedFilter)
        
        cell.selectionStyle = .none
        cell.titleText = title
        cell.isChecked = isChecked
    }
    
}

// MARK: - Factory
extension TrackersFilterViewController {
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Filters".localized()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }
    
    private func createTableView() -> UITableView {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(CategoryTableViewCell.self,
                      forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        return view
    }
    
}

// MARK: - UITableViewDelegate
extension TrackersFilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? CategoryTableViewCell
        cell?.isSeparatorViewHidden = (indexPath.row == filters.count - 1)
        var maskedCorners: CACornerMask = []
        if indexPath.row == 0 {
            maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if indexPath.row == filters.count - 1 {
            maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        cell?.layer.maskedCorners = maskedCorners
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        setSelectedFilter(filters[indexPath.row])
        onDidSelectCallback?(selectedFilter)
    }
    
}

// MARK: - UITableViewDataSource
extension TrackersFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell
        guard let cell else {
            return UITableViewCell()
        }
        configure(cell, at: indexPath)
        return cell
    }
    
}
