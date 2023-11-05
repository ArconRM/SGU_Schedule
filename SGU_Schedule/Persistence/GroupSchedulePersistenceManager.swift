//
//  GroupSchedulePersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.11.2023.
//

import Foundation

protocol GroupSchedulePersistenceManager: PersistenceManager {
    associatedtype ManagedModel = GroupSchedule
    associatedtype DTOModel = GroupScheduleDTO
}
