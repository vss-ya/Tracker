//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by vs on 15.04.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var nameTextField: UITextField = { createNameTextField() }()
    private lazy var clearNameButton: UIButton = { createClearNameButton() }()
    private lazy var tableView: UITableView = { createTableView() }()
    private lazy var cancelButton: UIButton = { createCancelButton() }()
    private lazy var createButton: UIButton = { createCreateButton() }()
    
    private let colors: [UIColor] = Constants.trackerColors
    
    private var options: [TrackerOption] = []
    private var schedule: [WeekDay] = []
    
    private var optionCellHeight: CGFloat = 75
    private var tableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var trackerKind: TrackerKind = .habit { didSet { trackerKindDidiChange() } }
    private var onCreateTrackerCallback: ((Tracker)->(Void))?
    
    convenience init(_ trackerKind: TrackerKind, onCreate: ((Tracker) -> Void)? = nil) {
        self.init()
        self.trackerKind = trackerKind
        self.onCreateTrackerCallback = onCreate
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
        clearNameButton.isHidden = true
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc private func createAction() {
        guard let text = nameTextField.text, !text.isEmpty else {
            return
        }
        let tracker = Tracker(title: text,
                                 color: colors[Int.random(in: 0..<colors.count)],
                                 emoji: "😜",
                                 schedule: schedule)
        onCreateTrackerCallback?(tracker)
    }
    
}

// MARK: - Helpers
extension CreateTrackerViewController {
    
    private func setup() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(headerLabel)
        view.addSubview(nameTextField)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 17))
        nameTextField.rightView?.addSubview(clearNameButton)
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 150)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            nameTextField.centerXAnchor.constraint(equalTo: headerLabel.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewHeightConstraint,
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width/2) - 4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width/2) + 4)
        ])
    }
    
    private func trackerKindDidiChange() {
        options = switch trackerKind {
        case .habit: 
            [.category, .schedule]
        default: 
            [.category]
        }
        switch trackerKind {
        case .irregular:
            schedule = WeekDay.allCases
        default:
            schedule = []
        }
        tableViewHeightConstraint.constant = CGFloat(options.count) * optionCellHeight
        tableView.reloadData()
    }
    
    private func showSchedule() {
        let vc = ScheduleViewController()
        vc.onDoneCallback = { [weak self] in
            guard let self else {
                return
            }
            schedule = $0
            dismiss(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - Factory
extension CreateTrackerViewController {
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.text = "Новая привычка"
        return label
    }
    
    private func createNameTextField() -> UITextField {
        let field = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .ypBackgroundGray
        field.layer.cornerRadius = 16
        field.leftView = leftView
        field.leftViewMode = .always
        field.keyboardType = .default
        field.returnKeyType = .done
        field.becomeFirstResponder()
        field.rightViewMode = .whileEditing
        field.placeholder = "Введите название трекера"
        field.delegate = self
        return field
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypBackgroundGray
        tableView.isScrollEnabled = false
        tableView.register(CreateTrackerTableViewCell.self,
                           forCellReuseIdentifier: CreateTrackerTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
    
    private func createClearNameButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Clean"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        btn.contentMode = .scaleAspectFit
        btn.isHidden = true
        btn.addTarget(self, action: #selector(clearNameAction), for: .touchUpInside)
        return btn
    }
    
    private func createCancelButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypRed, for: .normal)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.ypRed.cgColor
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.setTitle("Отменить", for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }
    
    private func createCreateButton() -> UIButton {
        let btn: UIButton = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.backgroundColor = .ypGray
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.isEnabled = false
        btn.setTitle("Создать", for: .normal)
        btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
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

// MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        clearNameButton.isHidden = text.isEmpty
        createButton.isEnabled = !text.isEmpty
        createButton.backgroundColor = !text.isEmpty ? .ypBlack :. ypGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            break
        case .schedule:
            showSchedule()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row != options.count - 1 else {
            return
        }
        cell.addSubview(createSeparatorViewForCell(cell))
    }
    
}

// MARK: - UITableViewDataSource
extension CreateTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CreateTrackerTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CreateTrackerTableViewCell
        guard let cell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.updateLabel(title: "Категория")
        case 1:
            cell.updateLabel(title: "Расписание")
        default:
            break
        }
        return cell
    }
    
}
