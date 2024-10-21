//
//  TeacherInfoViewModel.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 29.05.2024.
//

import Foundation

public final class TeacherInfoViewModel: ObservableObject {
    private let teacherNetworkManager: TeacherNetworkManager
    private let lessonsNetworkManager: LessonNetworkManager
    private let sessionEventsNetworkManager: SessionEventsNetworkManager
    
    @Published var teacher: Teacher? = nil
    @Published var teacherLessons: [LessonDTO] = []
    @Published var teacherSessionEvents: [SessionEventDTO] = []
    
    @Published var isLoadingTeacherInfo = true
    @Published var isLoadingTeacherLessons = true
    @Published var isLoadingTeacherSessionEvents = true
    
    @Published var isShowingError = false
    @Published var activeError: LocalizedError? = nil
    
    init(
        teacherNetworkManager: TeacherNetworkManager,
        lessonsNetworkManager: LessonNetworkManager,
        sessionEventsNetworkManager: SessionEventsNetworkManager
    ) {
        self.teacherNetworkManager = teacherNetworkManager
        self.lessonsNetworkManager = lessonsNetworkManager
        self.sessionEventsNetworkManager = sessionEventsNetworkManager
    }
    
    func fetchTeacherInfo(teacherEndpoint: String) {
        self.isLoadingTeacherInfo = true
        
        teacherNetworkManager.getTeacher(teacherEndpoint: teacherEndpoint, resultQueue: .main) { result in
            switch result {
            case .success(let teacher):
                self.teacher = teacher
                self.fetchTeacherLessons()
                self.fetchTeacherSessionEvents()
            case .failure(let error):
                self.showNetworkError(error: error)
            }
            self.isLoadingTeacherInfo = false
        }
    }
    
    func fetchTeacherLessons() {
        self.isLoadingTeacherLessons = true
        
        guard let _ = self.teacher else {
            self.showNetworkError(error: NetworkError.unexpectedError)
            return
        }
        
        lessonsNetworkManager.getTeacherScheduleForCurrentWeek(teacher: self.teacher!, resultQueue: .main) { result in
            switch result {
            case .success(let lessons):
                self.teacherLessons = lessons
            case .failure(let error):
                self.showNetworkError(error: error)
            }
            self.isLoadingTeacherLessons = false
        }
    }
    
    func fetchTeacherSessionEvents() {
        self.isLoadingTeacherSessionEvents = true
        
        guard let _ = self.teacher else {
            self.showNetworkError(error: NetworkError.unexpectedError)
            return
        }
        
        sessionEventsNetworkManager.getTeacherSessionEvents(teacher: self.teacher!, resultQueue: .main) { result in
            switch result {
            case .success(let sessionEvents):
                self.teacherSessionEvents = sessionEvents
            case .failure(let error):
                self.showNetworkError(error: error)
            }
            self.isLoadingTeacherSessionEvents = false
        }
    }
    
    private func showNetworkError(error: Error) {
        self.isShowingError = true
        
        if let networkError = error as? NetworkError {
            self.activeError = networkError
        } else {
            self.activeError = NetworkError.unexpectedError
        }
    }
}
