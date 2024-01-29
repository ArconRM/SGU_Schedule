//
//  GroupScheduleDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 03.11.2023.
//

import Foundation

public struct GroupScheduleDTO {
    
    var group: GroupDTO
    var lessons: [LessonDTO]
    
    init(groupNumber: Int, lessonsByDays: [LessonDTO]) {
        self.group = GroupDTO(fullNumber: groupNumber)
        self.lessons = lessonsByDays
    }
}
