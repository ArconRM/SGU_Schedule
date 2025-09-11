//
//  GroupSessionEventsPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class GroupSessionEventsPersistenceManagerMock: GroupSessionEventsPersistenceManager {
    func saveItem(_ itemDto: GroupSessionEventsDTO) throws -> GroupSessionEvents {
        return GroupSessionEvents()
    }

    func fetchAllItems() throws -> [GroupSessionEvents] {
        return []
    }

    func fetchAllItemsDTO() throws -> [GroupSessionEventsDTO] {
        return []
    }

    func getFavouriteGroupSessionEventsDTO() throws -> GroupSessionEventsDTO? {
        return nil
    }

    func getSessionEventsByGroupId(_ groupId: String) throws -> GroupSessionEventsDTO? {
        return nil
    }

    func clearAllItems() throws { }

    func deleteSessionEventsByGroupId(_ groupId: String) throws { }
}
