//
//  TrackersViewController.swift
//  Tracker
//
//  Created by vs on 04.04.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private lazy var addButton: UIButton = { createAddButton() }()
    private lazy var datePicker: UIDatePicker = { createDatePicker() }()
    private lazy var emptyTrackersImageView: UIImageView = { createEmptyTrackersImageView() }()
    private lazy var emptyTrackersLabel: UILabel = { createEmptyTrackersLabel() }()
    private lazy var emptySearchImageView: UIImageView = { createEmptySearchImageView() }()
    private lazy var emptySearchLabel: UILabel = { createEmptySearchLabel() }()
    private lazy var collectionView: UICollectionView = { createCollectionView() }()
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private var calendar: Calendar = Calendar.current
    private var selectedWeekday: Int {
        calendar.component(.weekday, from: datePicker.date)
    }
    private var searchText: String {
        navigationItem.searchController?.searchBar.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
}

// MARK: - Actions
extension TrackersViewController {
    
    @objc private func addAction() {
        let vc = AddTrackerViewController()
        vc.onCreateTrackerCallback = { [weak self] in
            guard let self else {
                return
            }
            add(tracker: $0, category: $1)
            dismiss(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChangedAction() {
        filterTrackers()
    }
    
}

// MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    
    func storeDidChange(_ store: TrackerStore) {
        trackers = store.trackers
        categories = trackerCategoryStore.trackerCategories
        filterTrackers()
    }
    
}

// MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerCategoryStoreDelegate {
    
    func storeDidChange(_ store: TrackerCategoryStore) {
        categories = store.trackerCategories
        filterTrackers()
    }
    
}

// MARK: - TrackerRecordStoreDelegate
extension TrackersViewController: TrackerRecordStoreDelegate {
    
    func storeDidChange(_ store: TrackerRecordStore) {
        completedTrackers = store.trackerRecords
        filterTrackers()
    }
    
}

// MARK: - Helpers
extension TrackersViewController {
    
    private func setup() {
        setupViews()
        setupConstraints()
        
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(emptyTrackersImageView)
        view.addSubview(emptyTrackersLabel)
        view.addSubview(emptySearchImageView)
        view.addSubview(emptySearchLabel)
        view.addSubview(collectionView)
        
        prepareNavigationBar()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyTrackersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackersImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTrackersImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyTrackersLabel.centerXAnchor.constraint(equalTo: emptyTrackersImageView.centerXAnchor),
            emptyTrackersLabel.topAnchor.constraint(equalTo: emptyTrackersImageView.bottomAnchor, constant: 8),
            emptySearchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptySearchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptySearchLabel.centerXAnchor.constraint(equalTo: emptySearchImageView.centerXAnchor),
            emptySearchLabel.topAnchor.constraint(equalTo: emptySearchImageView.bottomAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    private func prepareNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchController
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Trackers".localized()
    }
    
    private func loadData() {
        trackers = trackerStore.trackers
        completedTrackers = trackerRecordStore.trackerRecords
        categories = trackerCategoryStore.trackerCategories
        
        filterVisibleCategories()
        updateScreen()
    }
    
    private func showDefaultScreen() {
        let isEmpty = visibleCategories.isEmpty
        collectionView.isHidden = isEmpty
        emptyTrackersImageView.isHidden = !isEmpty
        emptyTrackersLabel.isHidden = !isEmpty
        emptySearchImageView.isHidden = isEmpty
        emptySearchLabel.isHidden = isEmpty
    }
    
    private func showSearchScreen() {
        let isEmpty = visibleCategories.isEmpty
        collectionView.isHidden = isEmpty
        emptyTrackersImageView.isHidden = isEmpty
        emptyTrackersLabel.isHidden = isEmpty
        emptySearchImageView.isHidden = !isEmpty
        emptySearchLabel.isHidden = !isEmpty
    }
    
    private func updateScreen() {
        if searchText.isEmpty {
            showDefaultScreen()
        } else {
            showSearchScreen()
        }
    }
    
    private func configure(_ cell: TrackerCollectionViewCell, at indexPath: IndexPath) {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompleted = isTrackerCompleted(id: tracker.id)
        let completedDays = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        cell.configure(tracker: tracker,
                       completedDays: completedDays,
                       isCompleted: isCompleted)
        { [weak self] in
            guard let self else {
                return
            }
            if isCompleted {
                removeCompletedTracker(tracker)
                collectionView.reloadItems(at: [indexPath])
            } else {
                addCompletedTracker(tracker)
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    private func filterVisibleCategories() {
        let pinnedTrackers = trackers.filter { $0.pinned }
        let pinnedCategory = TrackerCategory(header: "Pinned".localized(),
                                             trackers: pinnedTrackers)
        visibleCategories = ([pinnedCategory] + categories).enumerated().map { (index, category) in
            let trackers = category.trackers.filter { tracker in
                let scheduleContains = tracker.schedule?.contains { day in
                    return day.rawValue == selectedWeekday
                } ?? false
                let titleContains = tracker.title.contains(searchText) || searchText.isEmpty
                if index == 0 {
                    return scheduleContains && titleContains
                }
                let pinnedContains = pinnedTrackers.contains{ $0.id == tracker.id }
                return scheduleContains && titleContains && !pinnedContains
            }
            return TrackerCategory(header: category.header, trackers: trackers)
        }
        .filter {
            !$0.trackers.isEmpty
        }
        collectionView.reloadData()
    }
    
    private func filterTrackers() {
        filterVisibleCategories()
        updateScreen()
    }
    
    private func add(tracker: Tracker, category: TrackerCategory) {
        trackerStore.save(tracker)
        trackerCategoryStore.addToCategory(withHeader: category.header, tracker: tracker)
        filterTrackers()
    }
    
    private func pin(tracker: Tracker, _ pinned: Bool) {
        trackerStore.pin(id: tracker.id, pinned)
    }
    
    private func update(tracker: Tracker, category: TrackerCategory) {
        trackerStore.delete(id: tracker.id)
        trackerCategoryStore.delete(tracker: tracker.id)
        trackerStore.save(tracker)
        trackerCategoryStore.addToCategory(withHeader: category.header, tracker: tracker)
        filterTrackers()
    }
    
    private func delete(tracker: Tracker) {
        trackerStore.delete(id: tracker.id)
        trackerRecordStore.delete(id: tracker.id)
        trackerCategoryStore.delete(tracker: tracker.id)
        filterTrackers()
    }
    
    private func isTrackerCompleted(id: UUID) -> Bool {
        return completedTrackers.contains {
            $0.id == id && calendar.isDate($0.date, inSameDayAs: datePicker.date)
        }
    }
    
    private func addCompletedTracker(_ tracker: Tracker) {
        let id = tracker.id
        let presentDate = Date()
        let selectedDate = datePicker.date
        let comparisonResult = calendar.compare(selectedDate, to: presentDate, toGranularity: .day)
        guard comparisonResult != .orderedDescending else {
            return
        }
        let trackerRecord = TrackerRecord(id: id, date: selectedDate)
        trackerRecordStore.save(trackerRecord)
        
    }
    
    private func removeCompletedTracker(_ tracker: Tracker) {
        let id = tracker.id
        let selectedDate = datePicker.date
        let trackerRecord = completedTrackers.first {
            $0.id == id && calendar.isDate($0.date, inSameDayAs: selectedDate)
        }
        guard let trackerRecord else {
            return
        }
        trackerRecordStore.delete(trackerRecord)
    }
    
    private func menuActions(for indexPath: IndexPath) -> [UIAction] {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let pinAction = switch tracker.pinned {
        case true:
            UIAction(title: "Unpin".localized()) { [weak self] _ in
                guard let self else { return }
                pin(tracker: tracker, false)
            }
        case false:
            UIAction(title: "Pin".localized()) { [weak self] _ in
                guard let self else { return }
                pin(tracker: tracker, true)
            }
        }
        let editAction = UIAction(title: "Edit".localized()) { [weak self] _ in
            guard let self else { return }
            performEditAction(for: tracker)
        }
        let deleteAction = UIAction(title: "Delete".localized()) { [weak self] _ in
            guard let self else { return }
            performDeleteAction(for: tracker)
        }
        return [pinAction, editAction, deleteAction]
    }
    
    private func performDeleteAction(for tracker: Tracker) {
        let ac = UIAlertController(title: nil,
                                   message: "DeleteTrackerQuestion".localized(),
                                   preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete".localized(), style: .destructive) { [weak self] _ in
            guard let self else { return }
            delete(tracker: tracker)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        
        ac.addAction(deleteAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func performEditAction(for tracker: Tracker) {
        let category = categories.first {
            $0.trackers.contains {
                $0.id == tracker.id
            }
        }
        let completedDays = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        
        guard let category else {
            return
        }
        
        let vc = CreateTrackerViewController(
            tracker: tracker,
            category: category,
            completedDays: completedDays)
        { [weak self] in
            guard let self else {
                return
            }
            update(tracker: $0, category: $1)
            dismiss(animated: true, completion: nil)
        }
        present(vc, animated: true)
    }
    
}

// MARK: - Factory
extension TrackersViewController {
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "Трекеры"
        return label
    }
    
    private func createAddButton() -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "AddTracker"), for: .normal)
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }
    
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(datePickerValueChangedAction), for: .valueChanged)
        return datePicker
    }
    
    private func createSearchField() -> UISearchTextField {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Поиск".localized()
        searchField.delegate = self
        return searchField
    }
    
    private func createEmptyTrackersImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EmptyTrackers")
        return imageView
    }
    
    private func createEmptyTrackersLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "WhatToTrackQuestion".localized()
        return label
    }
    
    private func createEmptySearchImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EmptySearch")
        return imageView
    }
    
    private func createEmptySearchLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "NothingFound".localized()
        return label
    }
    
    private func createCollectionView() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = false
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.dataSource = self
        view.delegate = self
        view.register(TrackerCollectionViewCell.self, 
                      forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        view.register(TrackerCollectionHeaderView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: TrackerCollectionHeaderView.reuseIdentifier)
        return view
    }
    
    private func previewForCell( at indexPath: IndexPath) -> UIViewController? {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return nil
        }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let cellSize = cell.frame.size
        let cellPreview = TrackerCollectionViewCell()
        
        cellPreview.configurePreview(tracker: tracker)
        
        let vc = UIViewController()
        vc.view = cellPreview
        vc.view.layer.cornerRadius = 0
        vc.preferredContentSize = CGSize(
            width: cellSize.width,
            height: cellSize.width * 0.55
        )
        
        return vc
    }
    
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterTrackers()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterTrackers()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTrackers()
    }
    
}

// MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filterTrackers()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell
        guard let cell else {
            return UICollectionViewCell()
        }
        configure(cell, at: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCollectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionHeaderView
        guard let header else {
            return UICollectionReusableView()
        }
        guard indexPath.section < visibleCategories.count else {
            return header
        }
        let headerText = visibleCategories[indexPath.section].header
        header.title = headerText
        return header
    }
    
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] () -> UIViewController? in
                guard let self else { return nil }
                
                return self.previewForCell(at: indexPath)
            },
            actionProvider: { [weak self] _ in
                let actions = self?.menuActions(for: indexPath) ?? []
                return UIMenu(title: "", children: actions)
            }
        )
        return configuration
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset.width
        let width = (collectionView.bounds.width - inset) / 2 - 5
        return CGSize(width: width, height: width * 0.88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 47)
    }
    
}
