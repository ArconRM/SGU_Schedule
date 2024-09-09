//
//  LessonPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.11.2023.
//

import Foundation

protocol LessonPersistenceManager {
    func saveItem(_ itemDto: LessonDTO) throws -> Lesson
    
    func fetchAllItems() throws -> [Lesson]
    
    func fetchAllItemsDTO() throws -> [LessonDTO]
    
    func clearAllItems() throws
}
