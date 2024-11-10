//
//  NetworkingError.swift
//  SGU_Schedule
//
//  Created by Артемий on 26.09.2023.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case scraperError
    case htmlParserError
    case networkManagerError
    case unexpectedError
    
    public var errorDescription: String? {
        switch self {
        case .scraperError:
            return "Ошибка при получении html"
        case .htmlParserError:
            return "Ошибка парсера"
        case .networkManagerError:
            return "Ошибка получения данных"
        case .unexpectedError:
            return "Неожиданная ошибка"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .scraperError:
            return "Не получилось получить html сайта"
        case .htmlParserError:
            return "Не удалось распарсить данные с сайта"
        case .networkManagerError:
            return "Не удалось получить данные с сайта"
        case .unexpectedError:
            return "Неожиданная ошибка при получении данных с сайта"
        }
    }
}
