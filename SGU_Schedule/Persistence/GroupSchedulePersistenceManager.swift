//
//  GroupSchedulePersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.11.2023.
//

import Foundation

protocol GroupSchedulePersistenceManager {
    func saveItem(item: GroupScheduleDTO) throws -> GroupSchedule
    
    func fetchAllItemsDTO() throws -> [GroupScheduleDTO]
    
    func fetchAllManagedItems() throws -> [GroupSchedule]
    
    func clearAllItems() throws
}
