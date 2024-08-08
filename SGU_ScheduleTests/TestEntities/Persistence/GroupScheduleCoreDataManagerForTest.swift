//
//  GroupScheduleCoreDataManagerForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 06.02.2024.
//

import Foundation

///Заглушка
final class GroupScheduleCoreDataManagerForTest: GroupSchedulePersistenceManager {
    func saveItem(item: GroupScheduleDTO) throws -> GroupSchedule {
        throw CoreDataError.failedToSave
    }
    
    func fetchAllItemsDTO() throws -> [GroupScheduleDTO] {
        throw CoreDataError.failedToFetch
    }
    
    func fetchAllManagedItems() throws -> [GroupSchedule] {
        throw CoreDataError.failedToFetch
    }
    
    func clearAllItems() throws {
        throw CoreDataError.failedToClear
    }
}
