//
//  SessionEventsParserMock.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

final class SessionEventsParserMock: SessionEventsHTMLParser {
    func getGroupSessionEventsFromSource(
        source html: String,
        groupNumber: String,
        departmentCode: String
    ) throws -> GroupSessionEventsDTO {
        return GroupSessionEventsDTO.mock
    }

    func getSessionEventsFromSource(source html: String) throws -> [SessionEventDTO] {
        return SessionEventDTO.mocks
    }
}
