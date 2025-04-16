//
//  TeacherInfoViewModel.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 29.05.2024.
//

import Foundation

public class TeacherViewModel: BaseViewModel {
    private let teacherNetworkManager: TeacherNetworkManager
    private let lessonsNetworkManager: LessonNetworkManager
    private let sessionEventsNetworkManager: SessionEventsNetworkManager

    @Published var teacher: TeacherDTO?
    @Published var teacherLessons: [LessonDTO] = []
    @Published var teacherSessionEvents: [SessionEventDTO] = []

    @Published var isLoadingTeacherInfo = true
    @Published var isLoadingTeacherLessons = true
    @Published var isLoadingTeacherSessionEvents = true

    init(
        teacherNetworkManager: TeacherNetworkManager,
        lessonsNetworkManager: LessonNetworkManager,
        sessionEventsNetworkManager: SessionEventsNetworkManager
    ) {
        self.teacherNetworkManager = teacherNetworkManager
        self.lessonsNetworkManager = lessonsNetworkManager
        self.sessionEventsNetworkManager = sessionEventsNetworkManager
    }

    public func fetchAll(teacherUrlEndpoint: String) {
        self.isLoadingTeacherInfo = true

        teacherNetworkManager.getTeacher(teacherEndpoint: teacherUrlEndpoint, resultQueue: .main) { result in
            switch result {
            case .success(let teacher):
                self.teacher = teacher
                self.isLoadingTeacherInfo = false

                self.fetchTeacherLessons(teacherLessonsUrlEndpoint: teacher.lessonsUrlEndpoint)
                self.fetchTeacherSessionEvents(teacherSessionEventsUrlEndpoint: teacher.sessionEventsUrlEndpoint)
            case .failure(let error):
                self.showNetworkError(error)
            }
        }
    }

    public func fetchTeacherInfo(teacherUrlEndpoint: String) {
        self.isLoadingTeacherInfo = true

        teacherNetworkManager.getTeacher(teacherEndpoint: teacherUrlEndpoint, resultQueue: .main) { result in
            switch result {
            case .success(let teacher):
                self.teacher = teacher
            case .failure(let error):
                self.showNetworkError(error)
            }
            self.isLoadingTeacherInfo = false
        }
    }

    public func fetchTeacherLessons(teacherLessonsUrlEndpoint: String) {
        self.isLoadingTeacherLessons = true

        lessonsNetworkManager.getTeacherScheduleForCurrentWeek(teacherEndpoint: teacherLessonsUrlEndpoint, resultQueue: .main) { result in
            switch result {
            case .success(let lessons):
                self.teacherLessons = lessons
            case .failure(let error):
                self.showNetworkError(error)
            }
            self.isLoadingTeacherLessons = false
        }
    }

    public func fetchTeacherSessionEvents(teacherSessionEventsUrlEndpoint: String) {
        self.isLoadingTeacherSessionEvents = true

        sessionEventsNetworkManager.getTeacherSessionEvents(teacherEndpoint: teacherSessionEventsUrlEndpoint, resultQueue: .main) { result in
            switch result {
            case .success(let sessionEvents):
                self.teacherSessionEvents = sessionEvents
            case .failure(let error):
                self.showNetworkError(error)
            }
            self.isLoadingTeacherSessionEvents = false
        }
    }
}
