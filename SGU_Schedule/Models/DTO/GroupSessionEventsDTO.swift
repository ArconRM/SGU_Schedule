//
//  GroupSessionEventsDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

struct GroupSessionEventsDTO: Equatable {

    var group: AcademicGroupDTO
    var sessionEvents: [SessionEventDTO]

    init(groupNumber: String, departmentCode: String, sessionEvents: [SessionEventDTO]) {
        self.group = AcademicGroupDTO(fullNumber: groupNumber, departmentCode: departmentCode)
        self.sessionEvents = sessionEvents
    }

    static var mock: Self {
        .init(
            groupNumber: AcademicGroupDTO.mock.fullNumber,
            departmentCode: AcademicGroupDTO.mock.departmentCode,
            sessionEvents: SessionEventDTO.mocks
        )
    }

    func getNextConsultationAndExam() -> (consultation: SessionEventDTO?, exam: SessionEventDTO?) {
        let now = Date.now
//        guard let closestExamSubject = sessionEvents.filter( { $0.date >= now }).min(by: { $0.date < $1.date })?.title else {
        guard let closestExamSubject = sessionEvents.filter( { $0.date.isToday() || $0.date.isInFuture() }).min(by: { $0.date < $1.date })?.title else {
            return (consultation: nil, exam: nil)
        }

        let closestExam = sessionEvents.filter( { $0.title == closestExamSubject && $0.sessionEventType != .consultation }).first
        let closestConsultation = sessionEvents.filter( { $0.title == closestExamSubject && $0.sessionEventType == .consultation }).first

        return (consultation: closestConsultation, exam: closestExam)
    }
}
