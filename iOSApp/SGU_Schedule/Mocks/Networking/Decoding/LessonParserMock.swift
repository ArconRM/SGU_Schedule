//
//  LessonParserMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation
import SguParser

final class LessonParserMock: LessonHTMLParser {
    func getGroupScheduleFromSource(
        source html: String,
        groupNumber: String,
        departmentCode: String
    ) throws -> GroupScheduleDTO {
        return GroupScheduleDTO.mock
    }

    func getScheduleFromSource(source html: String) throws -> [LessonDTO] {
        return LessonDTO.mocks
    }
}
