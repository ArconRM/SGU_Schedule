//
//  GroupPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.09.2024.
//

import Foundation

protocol GroupPersistenceManager {
    func saveItem(_ itemDto: AcademicGroupDTO) throws -> AcademicGroup

    func fetchAllItems() throws -> [AcademicGroup]

    func fetchAllItemsDTO() throws -> [AcademicGroupDTO]

    func getFavouriteGroupDTO() throws -> AcademicGroupDTO?

    func deleteItemById(_ groupId: String) throws

    func clearAllItems() throws

    /// Если уже была избранная, изменит у нее флаг, так как избранной может быть только одна
    func makeGroupFavourite(_ groupId: String) throws
}
