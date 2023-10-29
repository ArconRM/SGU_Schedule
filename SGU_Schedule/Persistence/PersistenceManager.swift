//
//  LessonsPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation
import CoreData

public protocol PersistenceManager {
    associatedtype ManagedModel: NSManagedObject
    associatedtype DTOModel
    
    func saveItem(item: DTOModel) throws
    
    func saveItems(items: [DTOModel]) throws
    
    func fetchAllItems() throws -> [DTOModel]
    
    func clearAllItems() throws
}
