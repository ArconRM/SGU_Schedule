//
//  LessonNetworkManagerForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class LessonNetworkManagerForTest: LessonNetworkManager {
    func getGroupScheduleForCurrentWeek(group: AcademicGroupDTO,
                                        resultQueue: DispatchQueue,
                                        completionHandler: @escaping (Result<GroupScheduleDTO, Error>) -> Void) {
        Task { () -> Result<GroupScheduleDTO, Error> in
            return .success(GroupScheduleDTO(groupNumber: group.fullNumber, 
                                             departmentCode: group.departmentCode,
                                             lessonsByDays: [LessonDTO(subject: "МАТАН",
                                                                       teacherFullName: "Легенда",
                                                                       teacherEndpoint: "/person/timofeev-vladimir-grigorevich",
                                                                       lessonType: .lecture,
                                                                       weekDay: .monday,
                                                                       weekType: .all,
                                                                       cabinet: "Ад",
                                                                       lessonNumber: 1,
                                                                       timeStart: "08:20",
                                                                       timeEnd: "09:50"),
                                                             
                                                             LessonDTO(subject: "МАТАН",
                                                                       teacherFullName: "Легенда",
                                                                       lessonType: .practice,
                                                                       weekDay: .monday,
                                                                       weekType: .all,
                                                                       cabinet: "Ад",
                                                                       lessonNumber: 2,
                                                                       timeStart: "10:00",
                                                                       timeEnd: "11:30")]))
        }
    }
    
    func getTeacherScheduleForCurrentWeek(teacherEndpoint: String?,
                                          resultQueue: DispatchQueue,
                                          completionHandler: @escaping (Result<[LessonDTO], any Error>) -> Void) {
        Task { () -> Result<[LessonDTO], Error> in
            return .success([LessonDTO(subject: "МАТАН",
                                       teacherFullName: "Легенда",
                                       teacherEndpoint: "/person/timofeev-vladimir-grigorevich",
                                       lessonType: .lecture,
                                       weekDay: .monday,
                                       weekType: .all,
                                       cabinet: "Ад",
                                       lessonNumber: 1,
                                       timeStart: "08:20",
                                       timeEnd: "09:50"),
                             
                             LessonDTO(subject: "МАТАН",
                                       teacherFullName: "Легенда",
                                       lessonType: .practice,
                                       weekDay: .monday,
                                       weekType: .all,
                                       cabinet: "Ад",
                                       lessonNumber: 2,
                                       timeStart: "10:00",
                                       timeEnd: "11:30")])
        }
    }
    
}
