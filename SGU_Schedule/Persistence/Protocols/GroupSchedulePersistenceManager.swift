//
//  GroupSchedulePersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.11.2023.
//

import Foundation

protocol GroupSchedulePersistenceManager {
    func saveItem(_ itemDto: GroupScheduleDTO) throws -> GroupSchedule

    func fetchAllItems() throws -> [GroupSchedule]

    func fetchAllItemsDTO() throws -> [GroupScheduleDTO]

    func getFavouriteGroupScheduleDTO() throws -> GroupScheduleDTO?

    func getScheduleByGroupId(_ groupId: String) throws -> GroupScheduleDTO?

    func clearAllItems() throws

    func deleteScheduleByGroupId(_ groupId: String) throws
}
