//
//  CoreDataError.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation

public enum CoreDataError: Error, LocalizedError {
    case failedToSave
    case failedToFetch
    case failedToDelete
    case failedToUpdate
    case unexpectedError

    public var errorDescription: String? {
        switch self {
        case .failedToSave:
            return "Ошибка сохранения"
        case .failedToFetch:
            return "Ошибка получения"
        case .failedToDelete:
            return "Ошибка удаления"
        case .failedToUpdate:
            return "Ошибка изменения"
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
        case .failedToDelete:
            return "Не удалось удалить предыдущие данные с устройства"
        case .failedToUpdate:
            return "Не удалось изменить данные на устройстве"
        case .unexpectedError:
            return "Неожиданная ошибка при работе с данными на устройстве"
        }
    }
}
