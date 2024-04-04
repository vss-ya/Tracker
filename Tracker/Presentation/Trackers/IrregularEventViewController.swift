//
//  IrregularEventViewController.swift
//  Tracker
//
//  Created by vs on 05.04.2024.
//

import UIKit

final class IrregularEventViewController: UIViewController {

    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var nameTextField: UITextField = { createNameTextField() }()
    private lazy var clearNameButton: UIButton = { createClearNameButton() }()
    private lazy var tableView: UITableView = { createTableView() }()
    private lazy var cancelButton: UIButton = { createCancelButton() }()
    private lazy var createButton: UIButton = { createCreateButton() }()
    
    private let colors: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3,
        .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9,
        .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
        .ypColorSelection16, .ypColorSelection17, .ypColorSelection18
    ]
    
    var onCreateTrackerCallback: ((Tracker)->(Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    private func addSubviews() {
        view.addSubview(headerLabel)
        view.addSubview(nameTextField)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
    }
    
}

// MARK: - Actions
extension IrregularEventViewController {
    
    @objc private func clearNameAction() {
        nameTextField.text = ""
        clearNameButton.isHidden = true
    }
    
    @objc private func cancelButtonAction() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonAction() {
        guard let text = nameTextField.text, !text.isEmpty else {
            return
        }
        let tracker = Tracker(title: text,
                                 color: colors[Int.random(in: 0..<colors.count)],
                                 emoji: "😜",
                                 schedule: WeekDay.allCases)
        onCreateTrackerCallback?(tracker)
    }
    
}

// MARK: - Helpers
extension IrregularEventViewController {
    
    private func prepare() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(headerLabel)
        view.addSubview(nameTextField)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 17))
        nameTextField.rightView?.addSubview(clearNameButton)
        
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
            tableView.heightAnchor.constraint(equalToConstant: 149),
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
    
}

// MARK: - Factory
extension IrregularEventViewController {
    
    private func createHeaderLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.text = "Новое нерегулярное событие"
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
        tableView.register(IrregularEventTableViewCell.self,
                           forCellReuseIdentifier: IrregularEventTableViewCell.reuseIdentifier)
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
        btn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
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
        btn.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
        return btn
    }
    
}

// MARK: - UITextFieldDelegate
extension IrregularEventViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        clearNameButton.isHidden = text.isEmpty
        createButton.isEnabled = !text.isEmpty
        createButton.backgroundColor = !text.isEmpty ? .ypBlack : .ypGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - UITableViewDelegate
extension IrregularEventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension IrregularEventViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: IrregularEventTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? IrregularEventTableViewCell
        guard let cell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "Категория"
        return cell
    }
    
}
