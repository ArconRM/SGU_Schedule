//
//  GroupSessionEventsCoreDataManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.01.2025.
//

import Foundation

struct GroupSessionEventsCoreDataManager: GroupSessionEventsPersistenceManager {
    private let viewContext = PersistenceController.shared.container.viewContext
    private let sessionEventManager = SessionEventCoreDataManager()
    private let groupManager = GroupCoreDataManager()

    func saveItem(_ itemDto: GroupSessionEventsDTO) throws -> GroupSessionEvents {
        do {
            let sessionEvents = GroupSessionEvents(context: viewContext)
            if let group = try groupManager.fetchAllItems().first(where: { $0.groupId == itemDto.group.groupId }) {
                sessionEvents.group = group
            } else {
                throw CoreDataError.failedToSave
            }

            var newSessionEvents: [SessionEvent] = []
            for sessionEvent in itemDto.sessionEvents {
                newSessionEvents.append(try sessionEventManager.saveItem(sessionEvent))
            }
            sessionEvents.sessionEvents = NSOrderedSet(array: newSessionEvents)

            try viewContext.save()
            return sessionEvents
        } catch {
            throw CoreDataError.failedToSave
        }
    }

    func fetchAllItems() throws -> [GroupSessionEvents] {
        do {
            if try viewContext.count(for: GroupSessionEvents.fetchRequest()) == 0 {
                return []
            }

            let sessionEventsByGroups = try viewContext.fetch(GroupSessionEvents.fetchRequest())
            return sessionEventsByGroups
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func fetchAllItemsDTO() throws -> [GroupSessionEventsDTO] {
        do {
            if try viewContext.count(for: GroupSessionEvents.fetchRequest()) == 0 {
                return []
            }

            let managedSessionEventsByGroups = try viewContext.fetch(GroupSessionEvents.fetchRequest())
            var resultSessionEventsByGroups = [GroupSessionEventsDTO]()

            for managedSessionEventsByGroup in managedSessionEventsByGroups {
                var resultSessionEvents = [SessionEventDTO]()

                for managedSessionEvent in managedSessionEventsByGroup.sessionEvents?.array as? [SessionEvent] ?? [] {
                    let sessionEventDTO = SessionEventDTO(title: managedSessionEvent.title ?? "Error",
                                                          date: managedSessionEvent.date ?? Date.now,
                                                          sessionEventType: managedSessionEvent.sessionEventType,
                                                          teacherFullName: managedSessionEvent.teacherFullName ?? "Error",
                                                          cabinet: managedSessionEvent.cabinet ?? "Error")
                    resultSessionEvents.append(sessionEventDTO)

                }

                resultSessionEventsByGroups.append(
                    GroupSessionEventsDTO(
                        groupNumber: managedSessionEventsByGroup.group?.fullNumber ?? "Error",
                        departmentCode: managedSessionEventsByGroup.group?.departmentCode ?? "Error",
                        sessionEvents: resultSessionEvents
                    )
                )
            }

            return resultSessionEventsByGroups
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func getFavouriteGroupSessionEventsDTO() throws -> GroupSessionEventsDTO? {
        do {
            if try viewContext.count(for: GroupSessionEvents.fetchRequest()) == 0 {
                return nil
            }

            guard let managedGroupSessionEvents = try viewContext.fetch(GroupSessionEvents.fetchRequest()).first(where: { $0.group?.isFavourite ?? false }) else {
                return nil
            }

            var resultSessionEvents: [SessionEventDTO] = []
            for managedSessionEvent in managedGroupSessionEvents.sessionEvents?.array as? [SessionEvent] ?? [] {
                let sessionEventDTO = SessionEventDTO(title: managedSessionEvent.title ?? "Error",
                                                      date: managedSessionEvent.date ?? Date.now,
                                                      sessionEventType: managedSessionEvent.sessionEventType,
                                                      teacherFullName: managedSessionEvent.teacherFullName ?? "Error",
                                                      cabinet: managedSessionEvent.cabinet ?? "Error")
                resultSessionEvents.append(sessionEventDTO)
            }

            return GroupSessionEventsDTO(
                groupNumber: managedGroupSessionEvents.group?.fullNumber ?? "Error",
                departmentCode: managedGroupSessionEvents.group?.departmentCode ?? "Error",
                sessionEvents: resultSessionEvents
            )
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func getSessionEventsByGroupId(_ groupId: String) throws -> GroupSessionEventsDTO? {
        do {
            if try viewContext.count(for: GroupSessionEvents.fetchRequest()) == 0 {
                return nil
            }

            guard let managedGroupSessionEvents = try viewContext.fetch(GroupSessionEvents.fetchRequest()).first(where: { $0.group?.groupId == groupId }) else {
                return nil
            }

            var resultSessionEvents: [SessionEventDTO] = []
            for managedSessionEvent in managedGroupSessionEvents.sessionEvents?.array as? [SessionEvent] ?? [] {
                let sessionEventDTO = SessionEventDTO(title: managedSessionEvent.title ?? "Error",
                                                      date: managedSessionEvent.date ?? Date.now,
                                                      sessionEventType: managedSessionEvent.sessionEventType,
                                                      teacherFullName: managedSessionEvent.teacherFullName ?? "Error",
                                                      cabinet: managedSessionEvent.cabinet ?? "Error")
                resultSessionEvents.append(sessionEventDTO)
            }

            return GroupSessionEventsDTO(
                groupNumber: managedGroupSessionEvents.group?.fullNumber ?? "Error",
                departmentCode: managedGroupSessionEvents.group?.departmentCode ?? "Error",
                sessionEvents: resultSessionEvents
            )
        } catch {
            throw CoreDataError.failedToFetch
        }
    }

    func clearAllItems() throws {
        do {
            if try viewContext.count(for: GroupSessionEvents.fetchRequest()) == 0 {
                return
            }

            let prevSessionEvents = try self.fetchAllItems()
            for sessionEvents in prevSessionEvents {
                viewContext.delete(sessionEvents)
            }

            try viewContext.save()
        } catch {
            throw CoreDataError.failedToDelete
        }
    }

    func deleteSessionEventsByGroupId(_ groupId: String) throws {
        do {
            if try viewContext.count(for: GroupSessionEvents.fetchRequest()) == 0 {
                return
            }

            guard let managedSessionEvents = try viewContext.fetch(GroupSessionEvents.fetchRequest()).first(where: { $0.group?.groupId == groupId }) else {
                return
            }
            viewContext.delete(managedSessionEvents)

            try viewContext.save()
        } catch {
            throw CoreDataError.failedToDelete
        }
    }
}
