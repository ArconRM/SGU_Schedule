//
//  GroupSessionEventsDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

public struct GroupSessionEventsDTO {
    
    var group: GroupDTO
    var sessionEvents: [SessionEventDTO]
    
    init(groupNumber: Int, sessionEvents: [SessionEventDTO]) {
        self.group = GroupDTO(fullNumber: groupNumber)
        self.sessionEvents = sessionEvents
    }
}
