//
//  GroupSchedulePersistenceManagerMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 06.02.2024.
//

import Foundation
import SguParser

final class GroupSchedulePersistenceManagerMock: GroupSchedulePersistenceManager {
    func saveItem(_ itemDto: GroupScheduleDTO) throws -> GroupSchedule {
        return GroupSchedule()
    }

    func fetchAllItems() throws -> [GroupSchedule] {
        return []
    }

    func fetchAllItemsDTO() throws -> [GroupScheduleDTO] {
        return []
    }

    func getFavouriteGroupScheduleDTO() throws -> GroupScheduleDTO? {
        return nil
    }

    func getScheduleByGroupId(_ groupId: String) throws -> GroupScheduleDTO? {
        return nil
    }

    func clearAllItems() throws {
        throw CoreDataError.failedToDelete
    }

    func deleteScheduleByGroupId(_ groupId: String) throws {
        throw CoreDataError.failedToDelete
    }
}
