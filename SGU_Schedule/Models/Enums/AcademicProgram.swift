//
//  AcademicProgram.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public enum AcademicProgram: String, CaseIterable {
    case bachelorAndSpeciality = "Бакалавр/Специалитет"
    case masters = "Магистратура"
    case postgraduate = "Аспирантура"

    public init?(rawValue: String) {
        switch rawValue {
        case "Бакалавриат", "Специалитет":
            self = .bachelorAndSpeciality
        case "Магистратура":
            self = .masters
        case "Аспирантура":
            self = .postgraduate
        default:
            return nil
        }
    }

    public static var allStringCases: [String] = ["Бакалавр", "Специалитет", "Магистратура", "Аспирантура"]
}
