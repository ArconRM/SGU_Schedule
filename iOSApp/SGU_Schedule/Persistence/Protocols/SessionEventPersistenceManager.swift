//
//  SessionEventPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.01.2025.
//

import Foundation
import SguParser

protocol SessionEventPersistenceManager {
    func saveItem(_ itemDto: SessionEventDTO) throws -> SessionEvent

    func fetchAllItems() throws -> [SessionEvent]

    func fetchAllItemsDTO() throws -> [SessionEventDTO]

    func clearAllItems() throws
}
