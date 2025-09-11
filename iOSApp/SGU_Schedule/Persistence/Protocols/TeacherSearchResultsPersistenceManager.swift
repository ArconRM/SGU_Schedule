//
//  TeacherSearchResultsPersistenceManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 10.11.2024.
//

import Foundation
import SguParser

public protocol TeacherSearchResultsPersistenceManager {
    func save(_ results: Set<TeacherSearchResult> )

    func getAll() -> Set<TeacherSearchResult>?
}
