//
//  AddEditGroupView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 19.10.2021.
//

import UIKit

public class AddEditGroupView: UIViewController {
    // Table view properties
    private var tableView: UITableView!
    private static let imageAndTextFieldCellReuseIdentifier = "ImageAndTextFieldCell"
    private static let colorPickerCellReuseIdentifier = "ColorPickerCell"
    
    // Static cells
    private var nameTextField: UITextField!
    private var groupImageView: UIImageView!
    private var imageAndTextFieldCell: UITableViewCell!
    private var colorPickerCell: UITableViewCell!
    
    // VIPER properties
    public var presenter: AnyAddEditGroupPresenter?
    
    /// The group user is editing. If a new group is being added, this property is `nil`
    private var group: ToDoGroupModel?
    /// Available color options for the group
    private var colorOptions: [UIColor] = []
    /// The color that user has selected
    private var selectedColor: UIColor?
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up table view
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        view = tableView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.imageAndTextFieldCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.colorPickerCellReuseIdentifier)
        
        initializeCells()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Cell setup
    
    private func initializeCells() {
        imageAndTextFieldCell = tableView.dequeueReusableCell(withIdentifier: Self.imageAndTextFieldCellReuseIdentifier)
        colorPickerCell = tableView.dequeueReusableCell(withIdentifier: Self.colorPickerCellReuseIdentifier)
        
        // Image view
        
        let imageView = UIImageView()
        groupImageView = imageView
        
        imageAndTextFieldCell.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageAndTextFieldCell.contentView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: imageAndTextFieldCell.contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.masksToBounds = false
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 12
        
        // Text field
        
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.backgroundColor = .systemGroupedBackground
        textField.placeholder = NSLocalizedString("list_name_placeholder", comment: "")
        nameTextField = textField
        
        imageAndTextFieldCell.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            imageAndTextFieldCell.contentView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: imageAndTextFieldCell.contentView.leadingAnchor, constant: 32),
            imageAndTextFieldCell.contentView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 32)
        ])
    }
    
    private func setupColorPicker() {
        
    }
    
    private func setImageViewColor(_ color: UIColor) {
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, color])
        groupImageView.image = UIImage(systemName: "list.bullet.circle.fill")?.applyingSymbolConfiguration(config)
        groupImageView.layer.shadowColor = color.cgColor
    }
}

// MARK: - Module methods

extension AddEditGroupView: AnyAddEditGroupView {
    
    public func showAddScreen(withColorOptions colors: [UIColor]) {
        navigationItem.title = NSLocalizedString("add_list_title", comment: "")
        colorOptions = colors
        
        let color = colors.first ?? UIColor.systemBlue
        setImageViewColor(color)
        
        setupColorPicker()
    }
    
    public func showEditScreen(for group: ToDoGroupModel, withColorOptions colors: [UIColor]) {
        navigationItem.title = NSLocalizedString("edit_list_title", comment: "")
        colorOptions = colors
        
        self.group = group
        selectedColor = group.color
        
        setImageViewColor(selectedColor ?? UIColor.systemBlue)
        
        nameTextField.text = group.name
        
        setupColorPicker()
    }
}

// MARK: - Table view data source

extension AddEditGroupView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return imageAndTextFieldCell
        case 1:
            return colorPickerCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Table view delegate

extension AddEditGroupView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
