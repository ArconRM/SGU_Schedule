//
//  GroupsHTMLParser.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol GroupsHTMLParser {
    func getGroupsByYearAndAcademicProgramFromSource (
        source html: String,
        year: Int,
        departmentCode: String,
        program: AcademicProgram
    ) throws -> [AcademicGroupDTO]
}
