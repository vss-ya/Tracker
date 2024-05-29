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
    private lazy var filterButton: UIButton = { createFilterButton() }()
    
    private let notificationCenter = NotificationCenter.default
    private let store = Store.shared
    private let analytics = Analytics.shared
    
    private var trackers: [Tracker] = []
    private var trackerRecords: [TrackerRecord] = []
    private var trackerCategories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    
    private var calendar: Calendar = Calendar.current
    private var selectedWeekday: Int {
        calendar.component(.weekday, from: datePicker.date)
    }
    private var searchText: String {
        navigationItem.searchController?.searchBar.text ?? ""
    }
    
    private var selectedFilter: Filter {
        get { UserSettingsStorage.shared.filter }
        set { UserSettingsStorage.shared.filter = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analytics.open(screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analytics.close(screen: .main)
    }
    
}

// MARK: - Actions
extension TrackersViewController {
    
    @objc private func addAction() {
        analytics.click(screen: .main, item: .addTrack)
        let vc = AddTrackerViewController()
        vc.onCreateTrackerCallback = { [weak self] in
            guard let self else {
                return
            }
            store.save(tracker: $0, category: $1)
            dismiss(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChangedAction() {
        filterTrackers()
    }
    
    @objc private func filterAction() {
        analytics.click(screen: .main, item: .filter)
        let vc = TrackersFilterViewController(
            selectedFilter: selectedFilter) 
        { [weak self] filter in
            guard let self else { return }
            
            defer {
                dismiss(animated: true, completion: nil)
            }
            
            selectedFilter = filter
            
            switch filter {
            case .todayTrackers:
                selectedFilter = .allTrackers
                datePicker.date = Date()
            default:
                break
            }
            
            filterTrackers()
        }
        present(vc, animated: true)
    }
    
}

extension TrackersViewController {
    
    @objc private func storeDidUpdate() {
        loadData()
    }
    
}

// MARK: - Helpers
extension TrackersViewController {
    
    private func setup() {
        setupViews()
        setupConstraints()
        
        notificationCenter.addObserver(self,
                                       selector: #selector(storeDidUpdate),
                                       name: .storeDidUpdate,
                                       object: store)
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(emptyTrackersImageView)
        view.addSubview(emptyTrackersLabel)
        view.addSubview(emptySearchImageView)
        view.addSubview(emptySearchLabel)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
        
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
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
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
        title = L10n.trackers
    }
    
    private func loadData() {
        trackers = store.trackers
        trackerRecords = store.trackerRecords
        trackerCategories = store.trackerCategories
        filterTrackers()
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
        if trackers.isEmpty {
            showDefaultScreen()
        } else {
            showSearchScreen()
        }
        filterButton.backgroundColor = switch selectedFilter {
        case .completedTrackers, .notCompletedTrackers:
                .ypRed
        default:
                .ypBlue
        }
    }
    
    private func configure(_ cell: TrackerCollectionViewCell, at indexPath: IndexPath) {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompleted = isTrackerCompleted(id: tracker.id)
        let completedDays = trackerRecords.filter {
            $0.id == tracker.id
        }.count
        cell.configure(tracker: tracker,
                       completedDays: completedDays,
                       isCompleted: isCompleted)
        { [weak self] in
            guard let self else {
                return
            }
            analytics.click(screen: .main, item: .track)
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
        let pinnedCategory = TrackerCategory(header: L10n.pinned,
                                             trackers: pinnedTrackers)
        visibleCategories = ([pinnedCategory] + trackerCategories).enumerated().map { (index, category) in
            let trackers = category.trackers.filter { tracker in
                let scheduleContains = tracker.schedule?.contains { day in
                    return day.rawValue == selectedWeekday
                } ?? false
                let titleContains = tracker.title.contains(searchText) || searchText.isEmpty
                
                if index == 0 {
                    return scheduleContains && titleContains
                }
                
                let pinnedContains = pinnedTrackers.contains{ $0.id == tracker.id }
                var include = scheduleContains && titleContains && !pinnedContains
                
                switch selectedFilter {
                case .completedTrackers:
                    include = include && isTrackerCompleted(id: tracker.id)
                case .notCompletedTrackers:
                    include = include && !isTrackerCompleted(id: tracker.id)
                default:
                    break
                }
                
                return include
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
    
    private func isTrackerCompleted(id: UUID) -> Bool {
        return trackerRecords.contains {
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
        store.save(record: trackerRecord)
        
    }
    
    private func removeCompletedTracker(_ tracker: Tracker) {
        let id = tracker.id
        let selectedDate = datePicker.date
        let record = trackerRecords.first {
            $0.id == id && calendar.isDate($0.date, inSameDayAs: selectedDate)
        }
        guard let record else {
            return
        }
        store.delete(record: record)
    }
    
    private func menuActions(for indexPath: IndexPath) -> [UIAction] {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let pinAction = switch tracker.pinned {
        case true:
            UIAction(title: L10n.unpin) { [weak self] _ in
                guard let self else { return }
                store.pin(tracker: tracker, false)
            }
        case false:
            UIAction(title: L10n.pin) { [weak self] _ in
                guard let self else { return }
                store.pin(tracker: tracker, true)
            }
        }
        let editAction = UIAction(title: L10n.edit) { [weak self] _ in
            guard let self else { return }
            performEditAction(for: tracker)
        }
        let deleteAction = UIAction(title: L10n.delete, attributes: .destructive) { [weak self] _ in
            guard let self else { return }
            performDeleteAction(for: tracker)
        }
        return [pinAction, editAction, deleteAction]
    }
    
    private func performDeleteAction(for tracker: Tracker) {
        analytics.click(screen: .main, item: .delete)
        let ac = UIAlertController(title: nil,
                                   message: L10n.deleteTrackerQuestion,
                                   preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: L10n.delete, style: .destructive) { [weak self] _ in
            guard let self else { return }
            store.delete(tracker: tracker)
        }
        let cancelAction = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        
        ac.addAction(deleteAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func performEditAction(for tracker: Tracker) {
        analytics.click(screen: .main, item: .edit)
        let category = trackerCategories.first {
            $0.trackers.contains {
                $0.id == tracker.id
            }
        }
        let completedDays = trackerRecords.filter {
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
            store.update(tracker: $0, category: $1)
            dismiss(animated: true, completion: nil)
        }
        present(vc, animated: true)
    }
    
}

// MARK: - Factory
extension TrackersViewController {
    
    private func createAddButton() -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(.addTracker, for: .normal)
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }
    
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(datePickerValueChangedAction), for: .valueChanged)
        return datePicker
    }
    
    private func createSearchField() -> UISearchTextField {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = L10n.search
        searchField.delegate = self
        return searchField
    }
    
    private func createEmptyTrackersImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .emptyTrackers
        return imageView
    }
    
    private func createEmptyTrackersLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = L10n.whatToTrackQuestion
        return label
    }
    
    private func createEmptySearchImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .emptySearch
        return imageView
    }
    
    private func createEmptySearchLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = L10n.nothingFound
        return label
    }
    
    private func createCollectionView() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        view.allowsMultipleSelection = false
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 60, right: 16)
        view.dataSource = self
        view.delegate = self
        view.register(TrackerCollectionViewCell.self, 
                      forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier)
        view.register(TrackerCollectionHeaderView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: TrackerCollectionHeaderView.reuseIdentifier)
        return view
    }
    
    private func createFilterButton() -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 16
        btn.backgroundColor = .ypBlue
        btn.setTitle(L10n.filters, for: .normal)
        btn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        return btn
    }
    
    private func previewForCell(at indexPath: IndexPath) -> UIViewController? {
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
