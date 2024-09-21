//
//  AcademicProgram.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public enum AcademicProgram: String, CaseIterable {
    case BachelorAndSpeciality = "Бакалавр/Специалитет"
    case Masters = "Магистратура"
    case Postgraduate = "Аспирантура"
    
    public init?(rawValue: String) {
        switch rawValue {
        case "Бакалавриат", "Специалитет":
            self = .BachelorAndSpeciality
        case "Магистратура":
            self = .Masters
        case "Аспирантура":
            self = .Postgraduate
        default:
            return nil
        }
    }
}
