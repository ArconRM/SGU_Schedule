//
//  BaseError.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 01.11.2024.
//

import Foundation

public enum BaseError: Error, LocalizedError {
    case noSavedDataError
    case unknownError

    public var errorDescription: String? {
        switch self {
        case .noSavedDataError:
            return "Что-то не сохранилось"
        case .unknownError:
            return "Зря вы сюда жмакнули"
        }
    }

    public var failureReason: String? {
        switch self {
        case .noSavedDataError:
            return "Ошибка из-за несохранённых данных"
        case .unknownError:
            return "Все упало"
        }
    }
}
