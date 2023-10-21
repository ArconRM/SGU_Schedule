//
//  GroupsHTMLParser.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol GroupsHTMLParser {
//    func getAllGroupsFromSource(source html: String) -> [Group]
    func getGroupsByYearAndAcademicProgramFromSource(source html: String, year: Int, program: AcademicProgram) throws -> [Group]
}
