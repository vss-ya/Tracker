//
//  CategoryViewController.swift
//  Tracker
//
//  Created by vs on 14.05.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var emptyImageView: UIImageView = { createEmptyImageView() }()
    private lazy var emptyLabel: UILabel = { createEmptyLabel() }()
    private lazy var tableView: UITableView = { createTableView() }()
    private lazy var addButton: UIButton = { createAddButton() }()
    
    private var categoryViewModel: CategoryViewProtocol = CategoryViewModel()
    private var categories: [TrackerCategory] { categoryViewModel.categories }
    private var selectedCategory: TrackerCategory? { categoryViewModel.selectedCategory }
    private var selectedCategoryIndex: Int? { categoryViewModel.selectedCategoryIndex }
    
    var onDoneCallback: ((TrackerCategory)->(Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

// MARK: - Actions
extension CategoryViewController {
    
    @objc private func addAction() {
        let vc = CreateCategoryViewController { [weak self](category) in
            guard let self else {
                return
            }
            categoryViewModel.addCategory(header: category.header)
            categoryViewModel.selectCategory(header: category.header)
            dismiss(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - Helpers
extension CategoryViewController {
    
    func setSelectedCategory(_ category: TrackerCategory?) {
        guard let category else {
            return
        }
        categoryViewModel.selectCategory(header: category.header)
    }
    
    private func setup() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(headerLabel)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyImageView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        bind()
        updateViews()
    }
    
    private func bind() {
        categoryViewModel.onCategoriesStateChange = { [weak self](categories) in
            guard let self, isViewLoaded else { return }
            updateViews()
            tableView.reloadData()
        }
        categoryViewModel.onSelectedCategoryStateChange = { [weak self](category) in
            guard let self, isViewLoaded else { return }
            tableView.reloadData()
        }
    }
    
    private func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let title = "\(category.header)"
        let isChecked = (indexPath.row == selectedCategoryIndex)
        
        cell.selectionStyle = .none
        cell.titleText = title
        cell.isChecked = isChecked
    }
    
    private func updateViews() {
        let isEmpty = categories.isEmpty
        emptyImageView.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
}

// MARK: - Factory
extension CategoryViewController {
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.category
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        return label
    }
    
    private func createEmptyImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EmptyTrackers")
        return imageView
    }
    
    private func createEmptyLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = L10n.categoryEmptyText
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
    
    private func createAddButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.backgroundColor = .ypBlack
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.setTitle(L10n.addCategory, for: .normal)
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }
    
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? CategoryTableViewCell
        cell?.isSeparatorViewHidden = (indexPath.row == categories.count - 1)
        var maskedCorners: CACornerMask = []
        if indexPath.row == 0 {
            maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if indexPath.row == categories.count - 1 {
            maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        cell?.layer.maskedCorners = maskedCorners
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        categoryViewModel.selectCategory(at: indexPath.row)
        if let selectedCategory {
            onDoneCallback?(selectedCategory)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
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
