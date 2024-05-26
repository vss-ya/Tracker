//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by vs on 14.05.2024.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = { createScrollView() }()
    private lazy var headerLabel: UILabel = { createHeaderLabel() }()
    private lazy var nameTextField: UITextField = { createNameTextField() }()
    private lazy var nameClearButton: UIButton = { createNameClearButton() }()
    private lazy var doneButton: UIButton = { createDoneButton() }()
    
    private var name: String { (nameTextField.text ?? "").trimmed() }
    private var onCreateCallback: ((TrackerCategory)->(Void))?
    
    convenience init(_ onCreate: ((TrackerCategory) -> Void)? = nil) {
        self.init()
        self.onCreateCallback = onCreate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
}

// MARK: - Actions
extension CreateCategoryViewController {
    
    @objc private func clearNameAction() {
        nameTextField.text = ""
        nameClearButton.isHidden = true
    }
    
    @objc private func createAction() {
        let model = TrackerCategory(header: name, trackers: [])
        onCreateCallback?(model)
    }
    
}

// MARK: - Helpers
extension CreateCategoryViewController {
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(scrollView)
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(doneButton)
        
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 17))
        nameTextField.rightView?.addSubview(nameClearButton)
    }
    
    private func setupConstraints() {
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
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateViews() {
        let text = name
        let flags = [!text.isEmpty]
        let isEnabled = flags.filter({ !$0 }).isEmpty
        nameClearButton.isHidden = text.isEmpty
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled ? .ypBlack :. ypGray
    }
    
}

// MARK: - Factory
extension CreateCategoryViewController {
    
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
        label.text = "Новая категория"
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
        field.placeholder = "Введите название категории"
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
    
    private func createDoneButton() -> UIButton {
        let btn: UIButton = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.backgroundColor = .ypGray
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.isEnabled = false
        btn.setTitle("Готово", for: .normal)
        btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }
    
}

// MARK: - UITextFieldDelegate
extension CreateCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateViews()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
