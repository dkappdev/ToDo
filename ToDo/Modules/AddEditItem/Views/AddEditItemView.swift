//
//  AddEditItemView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 21.10.2021.
//

import UIKit

public class AddEditItemView: UIViewController {
    // Table view properties
    private var tableView: UITableView!
    private static let textFieldCellReuseIdentifier = "TextFieldCell"
    private static let dueDateCellReuseIdentifier = "DueDateCell"
    private static let datePickerCellReuseIdentifier = "DatePickerCell"
    
    // Static cells
    private var textField: UITextField!
    private var dueDateLabel: UILabel!
    private var dueDateSwitch: UISwitch!
    private var datePicker: UIDatePicker!
    private var textFieldCell: UITableViewCell!
    private var dueDateCell: UITableViewCell!
    private var datePickerCell: UITableViewCell!
    
    // VIPER properties
    public var presenter: AnyAddEditItemPresenter?
    
    /// The item user is editing. If a new item is being added, this property is equal to `nil`
    private var item: ToDoItemModel?
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up navigation bar
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped))
        
        // Setting up table view
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        view = tableView
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.textFieldCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.dueDateCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.datePickerCellReuseIdentifier)
        
        initializeCells()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Cell setup
    
    private func initializeCells() {
        textFieldCell = tableView.dequeueReusableCell(withIdentifier: Self.textFieldCellReuseIdentifier)
        dueDateCell = tableView.dequeueReusableCell(withIdentifier: Self.dueDateCellReuseIdentifier)
        datePickerCell = tableView.dequeueReusableCell(withIdentifier: Self.datePickerCellReuseIdentifier)
        
        // Text field
        
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = NSLocalizedString("todo_text_placeholder", comment: "")
        self.textField = textField
        
        textFieldCell.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldCell.contentView.layoutMarginsGuide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: textFieldCell.contentView.layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldCell.contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: textFieldCell.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        // Due date
        
        let dueDateLabel = UILabel()
        self.dueDateLabel = dueDateLabel
        
        dueDateCell.contentView.addSubview(dueDateLabel)
        dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dueDateLabel.leadingAnchor.constraint(equalTo: dueDateCell.contentView.layoutMarginsGuide.leadingAnchor),
            dueDateLabel.centerYAnchor.constraint(equalTo: dueDateCell.contentView.centerYAnchor)
        ])
        
        let dueDateSwitch = UISwitch()
        self.dueDateSwitch = dueDateSwitch
        
        dueDateCell.contentView.addSubview(dueDateSwitch)
        dueDateSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dueDateSwitch.trailingAnchor.constraint(equalTo: dueDateCell.contentView.layoutMarginsGuide.trailingAnchor),
            dueDateSwitch.centerYAnchor.constraint(equalTo: dueDateCell.contentView.centerYAnchor),
            dueDateSwitch.leadingAnchor.constraint(greaterThanOrEqualTo: dueDateLabel.trailingAnchor, constant: 16)
        ])
        
        // Date picker
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        self.datePicker = datePicker
        
        datePickerCell.contentView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerCell.contentView.layoutMarginsGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerCell.contentView.layoutMarginsGuide.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: datePickerCell.contentView.layoutMarginsGuide.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerCell.contentView.layoutMarginsGuide.bottomAnchor)
        ])
        
        datePicker.addTarget(self, action: #selector(dueDateChanged(_:)), for: .valueChanged)
        
        setupDateLabel()
    }
    
    // MARK: - Responding to user actions
    
    @objc private func cancelBarButtonTapped() {
        presenter?.dismiss()
    }
    
    @objc private func saveBarButtonTapped() {
        if dueDateSwitch.isOn {
            presenter?.saveItem(text: textField.text ?? "", dueDate: datePicker.date)
        } else {
            presenter?.saveItem(text: textField.text ?? "", dueDate: nil)
        }
        presenter?.dismiss()
    }
    
    @objc private func dueDateChanged(_ datePicker: UIDatePicker) {
        setupDateLabel()
    }
    
    // MARK: - Utility functions
    
    private func setupDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dueDateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
}

// MARK: - Module methods

extension AddEditItemView: AnyAddEditItemView {
    
    public func showAddScreen() {
        navigationItem.title = NSLocalizedString("add_item_title", comment: "")
    }
    
    public func showEditScreen(for item: ToDoItemModel) {
        navigationItem.title = NSLocalizedString("edit_item_title", comment: "")
        if let dueDate = item.dueDate {
            datePicker.date = dueDate
            dueDateSwitch.isOn = true
        }
        textField.text = item.text
        
        setupDateLabel()
    }
}

// MARK: - Table view data source

extension AddEditItemView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return textFieldCell
        case IndexPath(row: 0, section: 1):
            return dueDateCell
        case IndexPath(row: 1, section: 1):
            return datePickerCell
        default:
            return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("todo_text_section_name", comment: "")
        case 1:
            return NSLocalizedString("reminder_section_name", comment: "")
        default:
            return nil
        }
    }
}

// MARK: - Table view delegate

extension AddEditItemView: UITableViewDelegate {
    
}
