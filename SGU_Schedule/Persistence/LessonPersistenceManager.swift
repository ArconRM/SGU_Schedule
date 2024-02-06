//
//  LessonPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.11.2023.
//

import Foundation

protocol LessonPersistenceManager {
    func saveItem(item: LessonDTO) throws -> Lesson
    
    func fetchAllItemsDTO() throws -> [LessonDTO]
    
    func fetchAllManagedItems() throws -> [Lesson]
    
    func clearAllItems() throws
}
