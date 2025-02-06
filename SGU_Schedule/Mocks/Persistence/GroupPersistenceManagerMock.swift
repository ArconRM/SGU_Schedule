//
//  GroupPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class GroupPersistenceManagerMock: GroupPersistenceManager {
    func saveItem(_ itemDto: AcademicGroupDTO) throws -> AcademicGroup {
        return AcademicGroup()
    }

    func fetchAllItems() throws -> [AcademicGroup] {
        return []
    }

    func fetchAllItemsDTO() throws -> [AcademicGroupDTO] {
        return []
    }

    func getFavouriteGroupDTO() throws -> AcademicGroupDTO? {
        return nil
    }

    func deleteItemById(_ groupId: String) throws { }

    func clearAllItems() throws { }

    func makeGroupFavourite(_ groupId: String) throws { }
}
