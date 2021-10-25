//
//  ToDoItemListView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 18.10.2021.
//

import UIKit

public class ToDoItemListView: UIViewController {
    // Table view properties
    private static let toDoItemCellReuseIdentifier = "ToDoItemCell"
    private var tableView: UITableView!
    
    // Table view data source
    private typealias DataSourceType = UITableViewDiffableDataSource<Int, ToDoItemModel.ID>
    private var dataSource: DataSourceType!
    private static let defaultSectionIndex = 0
    
    // VIPER properties
    public var presenter: AnyToDoItemListPresenter?
    private var itemList: [ToDoItemModel] = []
    
    /// Cached group color
    private var groupColor: UIColor?
    
    // MARK: - View life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up table view
        tableView = UITableView(frame: view.frame, style: .grouped)
        dataSource = createDataSource()
        tableView.delegate = self
        view = tableView
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.toDoItemCellReuseIdentifier)
        
        // Setting up navigation item
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        presenter?.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTextColor(groupColor)
    }
    
    // MARK: - Responding to user actions
    
    /// Creates a new to-do item
    @objc private func addItem() {
        presenter?.addItem()
    }
    
    /// Delete to-do item at specified location
    /// - Parameter indexPath: item location
    private func deleteItem(at indexPath: IndexPath) {
        let item = itemList.remove(at: indexPath.row)
        presenter?.deleteItem(item)
        presenter?.requestUpdatedToDoGroup()
    }
    
    // MARK: - Utility functions
    
    /// Sets navigation bar color
    /// - Parameter color: new navigation bar color. If `color` is `nil`, no changes are made to the status bar
    private func setNavigationBarTextColor(_ color: UIColor?) {
        guard let color = color else { return }
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color as Any]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: color as Any]
    }
    
    // MARK: - Table view data source
    
    private func createDataSource() -> DataSourceType {
        return .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.toDoItemCellReuseIdentifier, for: indexPath)
            let item = self.itemList[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.text = item.text
            if let dueDate = item.dueDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                content.secondaryText = dateFormatter.string(from: dueDate)
                content.secondaryTextProperties.color = dueDate > Date() ? .secondaryLabel : .systemRed
            }
            
            if item.isCompleted {
                content.textProperties.color = .systemGray
                content.secondaryTextProperties.color = .systemGray
            }
            
            cell.contentConfiguration = content
            
            return cell
        }
    }
    
    private func updateTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ToDoItemModel.ID>()
        snapshot.appendSections([Self.defaultSectionIndex])
        
        let itemIdentifiers = itemList.map { $0.id }
        
        snapshot.appendItems(itemIdentifiers, toSection: Self.defaultSectionIndex)
        
        dataSource.apply(snapshot)
        
        snapshot.reconfigureItems(itemIdentifiers)
        dataSource.apply(snapshot)
    }
}

// MARK: - Module methods

extension ToDoItemListView: AnyToDoItemListView {
    /// Called when updated group model has been received. This method displays item list from the new group model
    /// - Parameter group: new group model
    public func showToDoItemsForGroup(_ group: ToDoGroupModel) {
        // Remembering group color
        groupColor = group.color
        
        // Setting up navigation bar
        setNavigationBarTextColor(groupColor)
        navigationItem.title = group.name
        
        // Displaying items
        itemList = group.items ?? []
        updateTableView()
    }
}

// MARK: - Table view delegate

extension ToDoItemListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
            self.deleteItem(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.accessibilityLabel = NSLocalizedString("delete_action_accessibility_label", comment: "")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = itemList[indexPath.row]
        let isCompleted = item.isCompleted
        let markAsCompletedAction = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            self.presenter?.toggleCompleted(for: item, isCompleted: !isCompleted)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presenter?.requestUpdatedToDoGroup()
            }
            
            completionHandler(true)
        }
        markAsCompletedAction.image = isCompleted ? UIImage(systemName: "text.badge.xmark") : UIImage(systemName: "text.badge.checkmark")
        markAsCompletedAction.backgroundColor = isCompleted ? .systemGray : .systemBlue
        markAsCompletedAction.accessibilityLabel = isCompleted ? NSLocalizedString("mark_as_completed_accessibility_label", comment: "") : NSLocalizedString("mark_as_not_completed_accessibility_label", comment: "")
        
        
        return UISwipeActionsConfiguration(actions: [markAsCompletedAction])
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemModel = itemList[indexPath.row]
        presenter?.editItem(itemModel)
    }
}
