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
    
    /// Last selected color picker view. This view is stored to restore its appearance after deselection.
    private var lastSelectedView: UIImageView?
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up navigation bar
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped))
        
        // Setting up table view
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        view = tableView
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
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
        let verticalSpacing: CGFloat = 16
        let horizontalSpacing: CGFloat = 16
        let imageSize: CGFloat = 40
        
        // Setting up vertical stack
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = verticalSpacing
        
        colorPickerCell.contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: colorPickerCell.contentView.topAnchor, constant: 16),
            colorPickerCell.contentView.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: colorPickerCell.contentView.leadingAnchor, constant: 16),
            colorPickerCell.contentView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 16)
        ])

        // Calculating number of columns and number fo rows
        
        let numberOfColumns = traitCollection.horizontalSizeClass == .regular ? 8 : 5
        
        var numberOfRows = colorOptions.count / numberOfColumns
        if colorOptions.count > numberOfRows * numberOfColumns {
            numberOfRows += 1
        }
        
        // Adding color options
        for (index, colorOption) in colorOptions.enumerated() {
            // Creating a new horizontal stack view for each new row
            if index % numberOfColumns == 0 {
                let horizontalStack = UIStackView()
                horizontalStack.axis = .horizontal
                horizontalStack.spacing = horizontalSpacing
                horizontalStack.alignment = .center
                horizontalStack.distribution = .fillEqually
                verticalStackView.addArrangedSubview(horizontalStack)
            }
            
            guard let stack = verticalStackView.arrangedSubviews.last as? UIStackView else { return }
            
            // Setting up image view
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: imageSize)
            ])
            
            setupImagePickerView(imageView, color: colorOption, isSelected: colorOption == selectedColor)
            
            if colorOption == selectedColor {
                lastSelectedView = imageView
            }
            
            imageView.tintColor = colorOption
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateColor(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(gestureRecognizer)
            
            stack.addArrangedSubview(imageView)
        }
        
        // Adding spacers
        
        for _ in 0..<(numberOfRows * numberOfColumns - colorOptions.count) {
            guard let stack = verticalStackView.arrangedSubviews.last as? UIStackView else { return }

            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: imageSize)
            ])
            
            stack.addArrangedSubview(imageView)
        }
    }
    
    private func setupImagePickerView(_ view: UIImageView?, color: UIColor, isSelected: Bool) {
        guard let view = view else { return }
        
        let paletteColors = isSelected ? [.white, color] : [color]
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: paletteColors)
        if isSelected {
            view.image = UIImage(systemName: "checkmark.circle.fill")?.applyingSymbolConfiguration(symbolConfiguration)
        } else {
            view.image = UIImage(systemName: "circle.fill")?.applyingSymbolConfiguration(symbolConfiguration)
        }
    }
    
    private func setImageViewColor(_ color: UIColor) {
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, color])
        groupImageView.image = UIImage(systemName: "list.bullet.circle.fill")?.applyingSymbolConfiguration(config)
        groupImageView.layer.shadowColor = color.cgColor
    }
    
    // MARK: - Responding to user actions
    
    @objc private func updateColor(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = gestureRecognizer.view as? UIImageView,
              let tintColor = view.tintColor else { return }
              
        setupImagePickerView(lastSelectedView, color: selectedColor ?? .systemBlue, isSelected: false)
        
        selectedColor = tintColor
        setImageViewColor(tintColor)
        setupImagePickerView(view, color: tintColor, isSelected: true)
        
        lastSelectedView = view
    }
    
    @objc private func cancelButtonTapped() {
        presenter?.dismiss()
    }
    
    @objc private func saveBarButtonTapped() {
        presenter?.saveGroup(name: nameTextField.text ?? "", color: selectedColor ?? .systemBlue)
        presenter?.dismiss()
    }
}

// MARK: - Module methods

extension AddEditGroupView: AnyAddEditGroupView {
    
    public func showAddScreen(withColorOptions colors: [UIColor]) {
        navigationItem.title = NSLocalizedString("add_list_title", comment: "")
        colorOptions = colors
        selectedColor = colorOptions.first
        
        let color = colors.first ?? UIColor.systemBlue
        setImageViewColor(color)
        
        setupColorPicker()
    }
    
    public func showEditScreen(for group: ToDoGroupModel, withColorOptions colors: [UIColor]) {
        navigationItem.title = NSLocalizedString("edit_list_title", comment: "")
        colorOptions = colors
        
        self.group = group
        selectedColor = group.color ?? colorOptions.first
        
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
