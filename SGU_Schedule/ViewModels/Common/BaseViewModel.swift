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

    func showError(_ error: Error) {
        isShowingError = true

        switch error {
        case let error as CoreDataError:
            activeError = error
        case let error as UserDefaultsError:
            activeError = error
        case let error as BaseError:
            activeError = error
        default:
            activeError = BaseError.unknownError
        }
    }
}
