//
//  Groups.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.09.2023.
//

import Foundation

enum GroupsSource: Int { // костыль
    case FIIT = 1 // фиит
    case IVT = 2 // ивт
    case CS = 3 // кб
    case MOAIS = 4 // моаис
    case PI = 5 // пи
    case PO = 6 // по
    case SAU = 8 // сау

    var shortName: String {
        switch self {
        case .FIIT:
            return "ФИИТ"
        case .IVT:
            return "ИВТ"
        case .CS:
            return "КБ"
        case .MOAIS:
            return "МОАИС"
        case .PI:
            return "ПИ"
        case .PO:
            return "ПО"
        case .SAU:
            return "САУ"
        }
    }

    var fullName: String {
        switch self {
        case .FIIT:
            return "Фундаментальная информатика и информационные технологии"
        case .IVT:
            return "Информатика и вычислительная техника"
        case .CS:
            return "Компьютерная безопасность"
        case .MOAIS:
            return "Математическое обеспечение и администрирование информационных систем"
        case .PI:
            return "Программная инженерия"
        case .PO:
            return "Педагогическое образование"
        case .SAU:
            return "Системный анализ и управление"
        }
    }

    init?(rawValue: Int) {
        if String(rawValue).count > 1 {
            switch Array(String(rawValue))[1] {
            case "1": self = .FIIT
            case "2": self = .IVT
            case "3": self = .CS
            case "4": self = .MOAIS
            case "5": self = .PI
            case "6": self = .PO
            case "8": self = .SAU
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
