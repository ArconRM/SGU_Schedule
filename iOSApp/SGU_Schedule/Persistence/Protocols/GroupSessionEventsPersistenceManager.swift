//
//  GroupSessionEventsPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.01.2025.
//

import Foundation

protocol GroupSessionEventsPersistenceManager {
    func saveItem(_ itemDto: GroupSessionEventsDTO) throws -> GroupSessionEvents

    func fetchAllItems() throws -> [GroupSessionEvents]

    func fetchAllItemsDTO() throws -> [GroupSessionEventsDTO]

    func getFavouriteGroupSessionEventsDTO() throws -> GroupSessionEventsDTO?

    func getSessionEventsByGroupId(_ groupId: String) throws -> GroupSessionEventsDTO?

    func clearAllItems() throws

    func deleteSessionEventsByGroupId(_ groupId: String) throws
}
