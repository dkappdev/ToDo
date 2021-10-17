//
//  ToDoGroupListView.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 17.10.2021.
//

import UIKit

public class ToDoGroupListView: UITableViewController {
    public static let toDoGroupCellReuseIdentifier = "ToDoGroupCell"
    
    public var presenter: AnyToDoGroupListPresenter?
    
    private var groupList: [ToDoGroupModel] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.toDoGroupCellReuseIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("group_list_title", comment: "")
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupList.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.toDoGroupCellReuseIdentifier, for: indexPath)
        let group = groupList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = group.name
        var image = UIImage(systemName: "list.bullet.circle.fill")
        if let color = group.color {
            image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        }
        content.image = image
        cell.contentConfiguration = content
        
        return cell
    }
}

extension ToDoGroupListView: AnyToDoGroupListView {
    
    public func showToDoGroups(_ groups: [ToDoGroupModel]) {
        groupList = groups
        tableView.reloadData()
    }
    
}
