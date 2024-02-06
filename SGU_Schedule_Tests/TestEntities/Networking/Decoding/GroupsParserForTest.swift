//
//  GroupsParserForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class GroupsParserForTest: GroupsHTMLParser {
    func getGroupsByYearAndAcademicProgramFromSource(source html: String, year: Int, program: AcademicProgram) throws -> [GroupDTO] {
        return [GroupDTO(fullNumber: 141), GroupDTO(fullNumber: 121), GroupDTO(fullNumber: 181)]
    }
}
