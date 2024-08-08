//
//  SessionEventsNetworkManagerForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class SessionEventsNetworkManagerForTest: SessionEventsNetworkManager {
    func getGroupSessionEvents(
        group: GroupDTO,
        departmentCode: String,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<GroupSessionEventsDTO, Error>) -> Void
    ) {
        Task { () -> Result<GroupSessionEventsDTO, Error> in
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = dateFormatter.date(from: "01.01.2069")!
            
            return .success(GroupSessionEventsDTO(groupNumber: group.fullNumber,
                                                  sessionEvents: [SessionEventDTO(title: "МАТАН",
                                                                                  date: date,
                                                                                  sessionEventType: .Consultation,
                                                                                  teacherFullName: "Легенда",
                                                                                  cabinet: "Ад")]))
        }
    }
    
    func getTeacherSessionEvents(
        teacher: TeacherDTO,
        resultQueue: DispatchQueue,
        completionHandler: @escaping (Result<[SessionEventDTO], any Error>) -> Void
    ) {
        Task { () -> Result<[SessionEventDTO], Error> in
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = dateFormatter.date(from: "01.01.2069")!
            
            return .success([SessionEventDTO(title: "МАТАН",
                                             date: date,
                                             sessionEventType: .Consultation,
                                             teacherFullName: "Легенда",
                                             cabinet: "Ад")])
        }
    }
}
