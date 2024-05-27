//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by vs on 15.04.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = { createScrollView() }()
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var nameTextField: UITextField = { createNameTextField() }()
    private lazy var nameClearButton: UIButton = { createNameClearButton() }()
    private lazy var tableView: UITableView = { createTableView() }()
    private lazy var emojiCollectionView: UICollectionView = { createEmojiCollectionView() }()
    private lazy var colorCollectionView: UICollectionView = { createColorCollectionView() }()
    private lazy var cancelButton: UIButton = { createCancelButton() }()
    private lazy var createButton: UIButton = { createCreateButton() }()
    
    private let emojis: [String] = Constants.trackerEmojis
    private let colors: [UIColor] = Constants.trackerColors
    
    private var name: String { (nameTextField.text ?? "").trimmed() }
    private var options: [TrackerOption] = []
    private var category: TrackerCategory?
    private var schedule: [WeekDay] = []
    private var emoji: String?
    private var color: UIColor?
    
    private var optionCellHeight: CGFloat = 75
    private var tableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var trackerKind: TrackerKind = .habit { didSet { trackerKindDidiChange() } }
    private var onCreateCallback: ((Tracker, TrackerCategory)->(Void))?
    
    convenience init(_ trackerKind: TrackerKind, onCreate: ((Tracker, TrackerCategory) -> Void)? = nil) {
        self.init()
        self.trackerKind = trackerKind
        self.onCreateCallback = onCreate
        self.trackerKindDidiChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        trackerKindDidiChange()
    }
    
}

// MARK: - Actions
extension CreateTrackerViewController {
    
    @objc private func clearNameAction() {
        nameTextField.text = ""
        nameClearButton.isHidden = true
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc private func createAction() {
        guard
            let category = category,
            let emoji = emoji,
            let color = color else
        {
            return
        }
        let tracker = Tracker(id: UUID(),
                              title: name,
                              color: color,
                              emoji: emoji,
                              schedule: schedule)
        onCreateCallback?(tracker, category)
    }
    
}

// MARK: - Helpers
extension CreateTrackerViewController {
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(scrollView)
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(tableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(createButton)
        scrollView.addSubview(cancelButton)
        
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 17))
        nameTextField.rightView?.addSubview(nameClearButton)
    }
    
    private func setupConstraints() {
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 150)
        
        let emojiCollectionHeightConstraint = emojiCollectionView.heightAnchor.constraint(equalToConstant: 1)
        let colorCollectionHeightConstraint = colorCollectionView.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 26),
            headerLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 22),
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            nameTextField.centerXAnchor.constraint(equalTo: headerLabel.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            tableViewHeightConstraint,
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiCollectionHeightConstraint,
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionHeightConstraint,
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: colorCollectionView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: colorCollectionView.centerXAnchor, constant: 4)
        ])
        
        emojiCollectionView.layoutIfNeeded()
        emojiCollectionHeightConstraint.constant = emojiCollectionView.contentSize.height
        colorCollectionView.layoutIfNeeded()
        colorCollectionHeightConstraint.constant = colorCollectionView.contentSize.height
    }
    
    private func trackerKindDidiChange() {
        options = switch trackerKind {
        case .habit: 
            [.category, .schedule]
        default: 
            [.category]
        }
        schedule = switch trackerKind {
        case .habit:
            []
        default:
            WeekDay.allCases
        }
        tableViewHeightConstraint.constant = CGFloat(options.count) * optionCellHeight
        tableView.reloadData()
    }
    
    private func showCategory() {
        let vc = CategoryViewController()
        vc.setSelectedCategory(category)
        vc.onDoneCallback = { [weak self] in
            guard let self else {
                return
            }
            category = $0
            updateViews()
            dismiss(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func showSchedule() {
        let vc = ScheduleViewController()
        vc.setSelectedWeekDays(schedule)
        vc.onDoneCallback = { [weak self] in
            guard let self else {
                return
            }
            schedule = $0
            updateViews()
            dismiss(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func updateViews() {
        let text = name
        let flags = [!text.isEmpty, category != nil, !schedule.isEmpty, emoji != nil, color != nil]
        let isEnabled = flags.filter({ !$0 }).isEmpty
        let categoryCell = tableView.cellForRow(at: .init(row: 0, section: 0))
        let scheduleCell = tableView.cellForRow(at: .init(row: 1, section: 0))
        
        if case let cell as TrackerOptionTableViewCell = categoryCell {
            cell.descriptionText = category?.header
        }
        
        if case let cell as TrackerOptionTableViewCell = scheduleCell {
            let description = switch schedule.count {
            case WeekDay.allCases.count:
                "EveryDay".localized()
            default:
                schedule.map({ $0.shortName }).joined(separator: ", ")
            }
            cell.descriptionText = description
        }
        
        nameClearButton.isHidden = text.isEmpty
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .ypBlack :. ypGray
    }
    
}

// MARK: - Factory
extension CreateTrackerViewController {
    
    private func createScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        return view
    }
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.text = "NewHabit".localized()
        return label
    }
    
    private func createNameTextField() -> UITextField {
        let field = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .ypBackgroundGray
        field.layer.cornerRadius = 16
        field.leftView = leftView
        field.leftViewMode = .always
        field.keyboardType = .default
        field.returnKeyType = .done
        field.becomeFirstResponder()
        field.rightViewMode = .whileEditing
        field.textColor = .ypBlack
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.placeholder = "EnterTrackerName".localized()
        field.delegate = self
        return field
    }
    
    private func createNameClearButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Clean"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        btn.contentMode = .scaleAspectFit
        btn.isHidden = true
        btn.addTarget(self, action: #selector(clearNameAction), for: .touchUpInside)
        return btn
    }
    
    private func createTableView() -> UITableView {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.register(TrackerOptionTableViewCell.self,
                      forCellReuseIdentifier: TrackerOptionTableViewCell.reuseIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }
    
    private func createEmojiCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TrackerEmojiCollectionHeaderView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: TrackerEmojiCollectionHeaderView.reuseIdentifier)
        view.register(TrackerEmojiCollectionViewCell.self,
                      forCellWithReuseIdentifier: TrackerEmojiCollectionViewCell.reuseIdentifier)
        view.allowsMultipleSelection = false
        view.dataSource = self
        view.delegate = self
        return view
    }
    
    private func createColorCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(TrackerColorCollectionHeaderView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: TrackerColorCollectionHeaderView.reuseIdentifier)
        view.register(TrackerColorCollectionViewCell.self,
                      forCellWithReuseIdentifier: TrackerColorCollectionViewCell.reuseIdentifier)
        view.allowsMultipleSelection = false
        view.dataSource = self
        view.delegate = self
        return view
    }
    
    private func createCancelButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypRed, for: .normal)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.ypRed.cgColor
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.setTitle("Cancel".localized(), for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }
    
    private func createCreateButton() -> UIButton {
        let btn: UIButton = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.backgroundColor = .ypGray
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.isEnabled = false
        btn.setTitle("Create".localized(), for: .normal)
        btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }
    
}

// MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateViews()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - UITableViewDataSource
extension CreateTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerOptionTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerOptionTableViewCell
        guard let cell else {
            return UITableViewCell()
        }
        cell.titleText = options[indexPath.row].title
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return optionCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch options[indexPath.row] {
        case .category:
            showCategory()
        case .schedule:
            showSchedule()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? TrackerOptionTableViewCell
        cell?.isSeparatorViewHidden = (indexPath.row == options.count - 1)
        var maskedCorners: CACornerMask = []
        if indexPath.row == 0 {
            maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if indexPath.row == options.count - 1 {
            maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        cell?.layer.maskedCorners = maskedCorners
    }
    
}

// MARK: - UICollectionViewDataSource
extension CreateTrackerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case emojiCollectionView:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerEmojiCollectionViewCell.reuseIdentifier, 
                for: indexPath
            ) as? TrackerEmojiCollectionViewCell
            guard let cell else {
                return UICollectionViewCell()
            }
            cell.emoji = emojis[indexPath.row]
            return cell
        case colorCollectionView:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerColorCollectionViewCell.reuseIdentifier, 
                for: indexPath
            ) as? TrackerColorCollectionViewCell
            guard let cell else {
                return UICollectionViewCell()
            }
            cell.color = colors[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case emojiCollectionView:
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerEmojiCollectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? TrackerEmojiCollectionHeaderView
            guard let view else {
                return UICollectionReusableView()
            }
            view.title = "Emoji"
            return view
        case colorCollectionView:
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerColorCollectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? TrackerColorCollectionHeaderView
            guard let view else {
                return UICollectionReusableView()
            }
            view.title = "Цвет"
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension CreateTrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case emojiCollectionView:
            emoji = emojis[indexPath.row]
        case colorCollectionView:
            color = colors[indexPath.row]
        default:
            break
        }
        updateViews()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.bounds.width - 36
        let cellWidth = viewWidth / 6
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
}
