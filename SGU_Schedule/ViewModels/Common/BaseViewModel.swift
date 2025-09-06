//
//  BaseViewModel.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.01.2025.
//

import Foundation
import OSLog

public class BaseViewModel: ObservableObject, ErrorPresentable {
    @Published var isShowingError: Bool = false
    @Published var activeError: (any LocalizedError)?

    func showError(_ error: Error) {
        isShowingError = true
        activeError = (error as? CoreDataError) ?? (error as? UserDefaultsError) ?? (error as? BaseError) ?? (error as? NetworkError) ?? BaseError.unknownError

       
        if activeError is BaseError {
            Logger.errorLogger.error("Unhandled error occurred in viewModel: \(error.localizedDescription, privacy: .public)")
        }
    }
}
