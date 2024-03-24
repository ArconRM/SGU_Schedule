//
//  LessonNetworkManagerForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class LessonNetworkManagerForTest: LessonNetworkManager {
    func getGroupScheduleForCurrentWeek(group: GroupDTO, resultQueue: DispatchQueue, completionHandler: @escaping (Result<GroupScheduleDTO, Error>) -> Void) {
        Task { () -> Result<GroupScheduleDTO, Error> in
            return .success(GroupScheduleDTO(groupNumber: group.fullNumber,
                                             lessonsByDays: [LessonDTO(subject: "МАТАН",
                                                                       lectorFullName: "Легенда",
                                                                       lectorUrl: URL(string: "https://www.sgu.ru/person/timofeev-vladimir-grigorevich"),
                                                                       lessonType: .Lecture,
                                                                       weekDay: .Monday,
                                                                       weekType: .All,
                                                                       cabinet: "Ад",
                                                                       lessonNumber: 1,
                                                                       timeStart: "08:20",
                                                                       timeEnd: "09:50"),
                                                             
                                                             LessonDTO(subject: "МАТАН",
                                                                       lectorFullName: "Легенда",
                                                                       lessonType: .Practice,
                                                                       weekDay: .Monday,
                                                                       weekType: .All,
                                                                       cabinet: "Ад",
                                                                       lessonNumber: 2,
                                                                       timeStart: "10:00",
                                                                       timeEnd: "11:30")]))
        }
    }
}
