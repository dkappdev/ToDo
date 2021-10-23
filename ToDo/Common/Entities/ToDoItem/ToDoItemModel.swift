//
//  ToDoItemModel.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 14.10.2021.
//

import Foundation
import UserNotifications

public class ToDoItemModel {
    /// Due date for item
    public var dueDate: Date?
    /// Date when the item was added
    public var dateAdded: Date?
    /// Unique item identifier
    public var id: UUID?
    /// Indicates whether or not to-do item is marked as complete
    public var isCompleted: Bool = false
    /// Text describing the to-do task
    public var text: String?
    /// Group that contains the item
    public var group: ToDoGroupModel?
    
    public init(dueDate: Date?, dateAdded: Date?, id: UUID?, isCompleted: Bool, text: String?, group: ToDoGroupModel?) {
        self.dueDate = dueDate
        self.dateAdded = dateAdded
        self.id = id
        self.isCompleted = isCompleted
        self.text = text
        self.group = group
    }
    
    public func updateNotifications() {
        // If due date is not specified for the item, remove all pending notifications
        guard let dueDate = dueDate,
              !isCompleted else {
                  let notificationId = id?.uuidString ?? ""
                  UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
                  return
              }
        
        // Otherwise create a notification request
        // Since item ID is also used as the notification ID, all previous requests will be automatically removed
        
        let content = UNMutableNotificationContent()
        content.title = group?.name ?? ""
        content.body = text ?? ""
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = id?.uuidString ?? ""
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension ToDoItemModel: Hashable {
    public static func == (lhs: ToDoItemModel, rhs: ToDoItemModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
