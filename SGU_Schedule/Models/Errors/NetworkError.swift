//
//  NetworkingError.swift
//  SGU_Schedule
//
//  Created by Артемий on 26.09.2023.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case htmlParserError
    case networkManagerError
    case unexpectedError
    
    var errorDescription: String? {
        switch self {
        case .networkManagerError:
            return "Ошибка получения данных"
        case .htmlParserError:
            return "Ошибка парсера"
        case .unexpectedError:
            return "Неожиданная ошибка"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .networkManagerError:
            return "Не удалось получить данные с сайта"
        case .htmlParserError:
            return "Не удалось распарсить данные с сайта"
        case .unexpectedError:
            return "Неожиданная ошибка при получении данных с сайта"
        }
    }
}
