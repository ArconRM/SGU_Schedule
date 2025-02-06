//
//  TeacherParserMock.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.02.2025.
//

import Foundation

final class TeacherParserMock: TeacherHTMLParser {
    func getTeacherFromSource(source html: String) throws -> Teacher {
        return Teacher.mock
    }

    func getAllTeacherSearchResultsFromSource(source html: String) throws -> Set<TeacherSearchResult> {
        return Set(TeacherSearchResult.mocks)
    }
}
