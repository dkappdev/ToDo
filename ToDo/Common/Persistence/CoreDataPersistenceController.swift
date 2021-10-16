//
//  CoreDataPersistanceController.swift
//  ToDo
//
//  Created by Daniil Kostitsin on 16.10.2021.
//

import Foundation
import CoreData
import UIKit

/// Singleton class with utility functions and properties used by Core Data data managers
public class CoreDataPersistenceController {
    // MARK: - Instances
    
    private init() {
    }
    
    public static let shared = CoreDataPersistenceController()
    
    // MARK: - Properties
    
    public let context = (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).persistentContainer.viewContext
    
    public func saveContext() {
        (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).saveContext()
    }
}
