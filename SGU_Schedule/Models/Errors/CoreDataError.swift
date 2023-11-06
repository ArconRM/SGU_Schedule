//
//  CoreDataError.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation

enum CoreDataError: Error, LocalizedError {
    case failedToSave
    case failedToFetch
    case failedToClear
    case unexpectedError
    
    var errorDescription: String? {
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
    
    var failureReason: String? {
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
