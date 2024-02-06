//
//  PersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation
import CoreData

//с ним нормально наследоваться не получается(
public protocol PersistenceManager {
    associatedtype ManagedModel: NSManagedObject
    associatedtype DTOModel
    
    func saveItem(item: DTOModel) throws -> ManagedModel
    
    func fetchAllItemsDTO() throws -> [DTOModel]
    
    func fetchAllManagedItems() throws -> [ManagedModel]
    
    func clearAllItems() throws
}
