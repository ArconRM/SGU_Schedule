//
//  SessionEventCoreDataManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.01.2025.
//

import Foundation
import SguParser

struct SessionEventCoreDataManager: SessionEventPersistenceManager {
    private let viewContext = PersistenceController.shared.container.viewContext

    func saveItem(_ itemDto: SessionEventDTO) throws -> SessionEvent {
        do {
            let newSessionEvent = SessionEvent(context: viewContext)
            newSessionEvent.title = itemDto.title
            newSessionEvent.cabinet = itemDto.cabinet
            newSessionEvent.date = itemDto.date
            newSessionEvent.sessionEventType = itemDto.sessionEventType
            newSessionEvent.teacherFullName = itemDto.teacherFullName

            try viewContext.save()

            return newSessionEvent
        } catch {
            throw CoreDataError.failedToSave
        }
    }

    func fetchAllItems() throws -> [SessionEvent] {
        do {
            if try viewContext.count(for: SessionEvent.fetchRequest()) == 0 {
                return []
            }

            let sessionEvents = try viewContext.fetch(SessionEvent.fetchRequest())
            return sessionEvents
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func fetchAllItemsDTO() throws -> [SessionEventDTO] {
        do {
            if try viewContext.count(for: SessionEvent.fetchRequest()) == 0 {
                return []
            }

            let managedSessionEvents = try viewContext.fetch(SessionEvent.fetchRequest())
            var resultSessionEvents: [SessionEventDTO] = []
            for managedSessionEvent in managedSessionEvents {
                let resultSessionEvent = SessionEventDTO(title: managedSessionEvent.title ?? "Error",
                                                         date: managedSessionEvent.date ?? Date.now,
                                                         sessionEventType: managedSessionEvent.sessionEventType,
                                                         teacherFullName: managedSessionEvent.teacherFullName ?? "Error",
                                                         cabinet: managedSessionEvent.cabinet ?? "Error")
                resultSessionEvents.append(resultSessionEvent)
            }
            return resultSessionEvents
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func clearAllItems() throws {
        do {
            let prevSessionEvents = try self.fetchAllItems()
            for sessionEvent in prevSessionEvents {
                viewContext.delete(sessionEvent)
            }
            try viewContext.save()
        } catch {
            throw CoreDataError.failedToDelete
        }
    }
}
