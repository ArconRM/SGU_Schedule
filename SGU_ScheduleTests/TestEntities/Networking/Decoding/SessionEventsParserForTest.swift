//
//  SessionEventsParserForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class SessionEventsParserForTest: SessionEventsHTMLParser {
    func getGroupSessionEventsFromSource(source html: String, groupNumber: String, departmentCode: String) throws -> GroupSessionEventsDTO {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2069")!
        
        return GroupSessionEventsDTO(groupNumber: groupNumber, 
                                     departmentCode: departmentCode,
                                     sessionEvents: [SessionEventDTO(title: "МАТАН",
                                                                     date: date,
                                                                     sessionEventType: .consultation,
                                                                     teacherFullName: "Легенда",
                                                                     cabinet: "Ад")])
    }
    
    func getSessionEventsFromSource(source html: String) throws -> [SessionEventDTO] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: "01.01.2069")!
        
        return [SessionEventDTO(title: "МАТАН",
                                date: date,
                                sessionEventType: .consultation,
                                teacherFullName: "Легенда",
                                cabinet: "Ад")]
    }
}
