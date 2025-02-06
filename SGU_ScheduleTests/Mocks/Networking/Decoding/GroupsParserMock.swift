//
//  GroupsParserForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class GroupsParserForTest: GroupsHTMLParser {
    func getGroupsByYearAndAcademicProgramFromSource(source html: String, year: Int, departmentCode: String, program: AcademicProgram) throws -> [AcademicGroupDTO] {
        return [AcademicGroupDTO(fullNumber: "141", departmentCode: departmentCode),
                AcademicGroupDTO(fullNumber: "121", departmentCode: departmentCode),
                AcademicGroupDTO(fullNumber: "181", departmentCode: departmentCode)]
    }
}
