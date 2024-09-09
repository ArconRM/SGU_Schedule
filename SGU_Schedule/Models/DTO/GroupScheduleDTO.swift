//
//  GroupScheduleDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 03.11.2023.
//

import Foundation

public struct GroupScheduleDTO {
    
    var group: AcademicGroupDTO
    var lessons: [LessonDTO]
    
    init(groupNumber: String, departmentCode: String, lessonsByDays: [LessonDTO]) {
        self.group = AcademicGroupDTO(fullNumber: groupNumber, departmentCode: departmentCode)
        self.lessons = lessonsByDays
    }
}
