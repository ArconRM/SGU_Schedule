//
//  TeachersSearchViewModel.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 28.10.2024.
//

import Foundation

public class TeachersSearchViewModel: ObservableObject {
    private let teacherNetworkManager: TeacherNetworkManager
    private let teacherSearchResultsUDManager: TeacherSearchResultsPersistenceManager

    @Published var allTeachers: Set<TeacherSearchResult> = []

    @Published var isLoading = true

    @Published var needToLoad = false
    @Published var isShowingError = false
    @Published var activeError: LocalizedError?

    init(
        teacherNetworkManager: TeacherNetworkManager,
        teacherSearchResultsUDManager: TeacherSearchResultsPersistenceManager
    ) {
        self.teacherNetworkManager = teacherNetworkManager
        self.teacherSearchResultsUDManager = teacherSearchResultsUDManager
    }

    public func fetchSavedTeachers() {
        isLoading = true

        if let savedTeachers = teacherSearchResultsUDManager.getAll() {
            allTeachers = savedTeachers
        } else {
            needToLoad = true
        }

        isLoading = false
    }

    public func fetchNetworkTeachersAndSave() {
        isLoading = true
        needToLoad = false

        teacherNetworkManager.getAllTeachers(resultQueue: .main) { result in
            switch result {
            case .success(let teachers):
                self.teacherSearchResultsUDManager.save(teachers)
                self.allTeachers = teachers
                self.isLoading = false
            case .failure(let error):
                self.showNetworkError(error: error)
            }
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
