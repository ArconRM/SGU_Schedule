//
//  BaseViewModel.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.01.2025.
//

import Foundation

public class BaseViewModel: ObservableObject, ErrorPresentable {
    @Published var isShowingError: Bool = false
    @Published var activeError: (any LocalizedError)?

    func showCoreDataError(_ error: Error) {
        isShowingError = true

        if let coreDataError = error as? CoreDataError {
            activeError = coreDataError
        } else {
            activeError = CoreDataError.unexpectedError
        }
    }

    func showNetworkError(_ error: Error) {
        isShowingError = true

        if let networkError = error as? NetworkError {
            activeError = networkError
        } else {
            activeError = NetworkError.unexpectedError
        }
    }

    func showUDError(_ error: Error) {
        self.isShowingError = true

        if let udError = error as? UserDefaultsError {
            self.activeError = udError
        } else {
            self.activeError = UserDefaultsError.unexpectedError
        }
    }

    func showBaseError(_ error: Error) {
        self.isShowingError = true

        if let baseError = error as? BaseError {
            self.activeError = baseError
        } else {
            self.activeError = BaseError.unknownError
        }
    }
}
