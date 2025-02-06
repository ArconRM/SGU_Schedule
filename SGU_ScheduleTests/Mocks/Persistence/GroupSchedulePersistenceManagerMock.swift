//
//  GroupSchedulePersistenceManagerMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 06.02.2024.
//

import Foundation

final class GroupSchedulePersistenceManagerMock: GroupSchedulePersistenceManager {
    func saveItem(_ itemDto: GroupScheduleDTO) throws -> GroupSchedule {
        throw CoreDataError.failedToSave
    }
    
    func fetchAllItems() throws -> [GroupSchedule] {
        throw CoreDataError.failedToFetch
    }
    
    func fetchAllItemsDTO() throws -> [GroupScheduleDTO] {
        throw CoreDataError.failedToFetch
    }
    
    func getFavouriteGroupScheduleDTO() throws -> GroupScheduleDTO? {
        throw CoreDataError.failedToFetch
    }
    
    func getScheduleByGroupId(_ groupId: String) throws -> GroupScheduleDTO? {
        throw CoreDataError.failedToFetch
    }
    
    func clearAllItems() throws {
        throw CoreDataError.failedToDelete
    }
    
    func deleteScheduleByGroupId(_ groupId: String) throws {
        throw CoreDataError.failedToDelete
    }
}
