//
//  SessionEventsParserForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class SessionEventsParserForTest: SessionEventsHTMLParser {
    func getGroupSessionEventsFromSource(source html: String, groupNumber: Int) throws -> GroupSessionEventsDTO {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2069")!
        
        return GroupSessionEventsDTO(groupNumber: groupNumber,
                                     sessionEvents: [SessionEventDTO(title: "МАТАН",
                                                                     date: date,
                                                                     sessionEventType: .Consultation,
                                                                     teacherFullName: "Легенда",
                                                                     cabinet: "Ад")])
    }
}
