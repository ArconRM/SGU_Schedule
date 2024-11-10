//
//  UserDefaultsError.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 08.09.2024.
//

import Foundation

public enum UserDefaultsError: Error, LocalizedError {
    case failedToSave
    case failedToFetch
    case failedToClear
    case unexpectedError
    
    public var errorDescription: String? {
        switch self {
        case .failedToSave:
            return "Ошибка сохранения"
        case .failedToFetch:
            return "Ошибка получения"
        case .failedToClear:
            return "Ошибка удаления"
        case .unexpectedError:
            return "Неожиданная ошибка"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .failedToSave:
            return "Не удалось сохранить данные на устройство"
        case .failedToFetch:
            return "Не удалось получить данные с устройства"
        case .failedToClear:
            return "Не удалось удалить предыдущие данные с устройства"
        case .unexpectedError:
            return "Неожиданная ошибка при работе с данными на устройстве"
        }
    }
}
