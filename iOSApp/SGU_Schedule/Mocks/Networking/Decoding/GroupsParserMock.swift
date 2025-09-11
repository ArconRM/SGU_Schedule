//
//  GroupsParserMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

final class GroupsParserMock: GroupsHTMLParser {
    func getGroupsByYearAndAcademicProgramFromSource(
        source html: String,
        year: Int,
        departmentCode: String,
        program: AcademicProgram
    ) throws -> [AcademicGroupDTO] {
        return [AcademicGroupDTO.mock]
    }
}
