//
//  LessonParserForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class LessonParserForTest: LessonHTMLParser {
    func getGroupScheduleFromSource(source html: String, groupNumber: Int) throws -> GroupScheduleDTO {
        return GroupScheduleDTO(groupNumber: groupNumber,
                                lessonsByDays: [LessonDTO(subject: "МАТАН",
                                                          teacherFullName: "Легенда",
                                                          teacherEndpoint: "/person/timofeev-vladimir-grigorevich",
                                                          lessonType: .Lecture,
                                                          weekDay: .Monday,
                                                          weekType: .All,
                                                          cabinet: "Ад",
                                                          lessonNumber: 1,
                                                          timeStart: "08:20",
                                                          timeEnd: "09:50"),
                                                
                                                LessonDTO(subject: "МАТАН",
                                                          teacherFullName: "Легенда",
                                                          lessonType: .Practice,
                                                          weekDay: .Monday,
                                                          weekType: .All,
                                                          cabinet: "Ад",
                                                          lessonNumber: 2,
                                                          timeStart: "10:00",
                                                          timeEnd: "11:30")])
    }
    
    func getScheduleFromSource(source html: String) throws -> [LessonDTO] {
        return [LessonDTO(subject: "МАТАН",
                          teacherFullName: "Легенда",
                          teacherEndpoint: "/person/timofeev-vladimir-grigorevich",
                          lessonType: .Lecture,
                          weekDay: .Monday,
                          weekType: .All,
                          cabinet: "Ад",
                          lessonNumber: 1,
                          timeStart: "08:20",
                          timeEnd: "09:50"),
                
                LessonDTO(subject: "МАТАН",
                          teacherFullName: "Легенда",
                          lessonType: .Practice,
                          weekDay: .Monday,
                          weekType: .All,
                          cabinet: "Ад",
                          lessonNumber: 2,
                          timeStart: "10:00",
                          timeEnd: "11:30")]
    }
}
