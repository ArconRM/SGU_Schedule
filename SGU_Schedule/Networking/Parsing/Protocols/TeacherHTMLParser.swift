//
//  TeacherHTMLParser.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

public protocol TeacherHTMLParser {
    func getTeacherFromSource(source html: String) throws -> TeacherDTO
    func getAllTeacherSearchResultsFromSource(source html: String) throws -> Set<TeacherSearchResult>
}
