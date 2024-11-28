//
//  GroupSessionEventsDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

public struct GroupSessionEventsDTO {

    var group: AcademicGroupDTO
    var sessionEvents: [SessionEventDTO]

    init(groupNumber: String, departmentCode: String, sessionEvents: [SessionEventDTO]) {
        self.group = AcademicGroupDTO(fullNumber: groupNumber, departmentCode: departmentCode)
        self.sessionEvents = sessionEvents
    }
}
