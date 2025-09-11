//
//  SessionEventPersistenceManagerMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation
import SguParser

final class SessionEventPersistenceManagerMock: SessionEventPersistenceManager {
    func saveItem(_ itemDto: SessionEventDTO) throws -> SessionEvent {
        return SessionEvent()
    }

    func fetchAllItems() throws -> [SessionEvent] {
        return []
    }

    func fetchAllItemsDTO() throws -> [SessionEventDTO] {
        return []
    }

    func clearAllItems() throws { }
}
