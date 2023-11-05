//
//  LessonPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.11.2023.
//

import Foundation

protocol LessonPersistenceManager: PersistenceManager {
    associatedtype ManagedModel = Lesson
    associatedtype DTOModel = LessonDTO
}
