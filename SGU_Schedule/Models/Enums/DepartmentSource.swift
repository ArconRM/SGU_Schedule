//
//  DepartmentSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 08.02.2024.
//

import Foundation

public enum DepartmentSource: String, CaseIterable {
    case bf = "bf"
    case gf = "gf"
    case gl = "gl"
    case idpo = "idpo"
    case ii = "ii"
    case imo = "imo"
    case ff = "ff"
    case ifk = "ifk"
    case ifg = "ifg"
    case ih = "ih"
    case mm = "mm"
    case sf = "sf"
    case fi = "fi"
    case knt = "knt"
    case fps = "fps"
    case fppso = "fppso"
    case fmimt = "fmimt"
    case fp = "fp"
    case ef = "ef"
    case uf = "uf"
    
    public var fullName: String {
        switch self {
        case .bf:
            return "Биологический факультет"
        case .gf:
            return "Географический факультет"
        case .gl:
            return "Геологический факультет"
        case .idpo:
            return "Институт дополнительного профессионального образования"
        case .ii:
            return "Институт искусств"
        case .imo:
            return "Институт истории и международных отношений"
        case .ff:
            return "Институт физики"
        case .ifk:
            return "Институт физической культуры и спорта"
        case .ifg:
            return "Институт филологии и журналистики"
        case .ih:
            return "Институт химии"
        case .mm:
            return "Механико-математический факультет"
        case .sf:
            return "Социологический факультет"
        case .fi:
            return "Факультет иностранных языков и лингводидактики"
        case .knt:
            return "Факультет компьютерных наук и информационных технологий"
        case .fps:
            return "Факультет психологии"
        case .fppso:
            return "Факультет психолого-педагогического и специального образования"
        case .fmimt:
            return "Факультет фундаментальной медицины и медицинских технологий"
        case .fp:
            return "Философский факультет"
        case .ef:
            return "Экономический факультет"
        case .uf:
            return "Юридический факультет"
        }
    }
    
    public var shortName: String {
        switch self {
        case .bf:
            return "Био"
        case .gf:
            return "Гео"
        case .gl:
            return "ГеоЛ"
        case .idpo:
            return "ДПО"
        case .ii:
            return "Искусств"
        case .imo:
            return "ИМО"
        case .ff:
            return "Физ"
        case .ifk:
            return "ФизКульт"
        case .ifg:
            return "ФилЖур"
        case .ih:
            return "Хим"
        case .mm:
            return "МехМат"
        case .sf:
            return "Социо"
        case .fi:
            return "Иностр"
        case .knt:
            return "КНИИТ"
        case .fps:
            return "Психолог"
        case .fppso:
            return "ППиСО"
        case .fmimt:
            return "Мед"
        case .fp:
            return "Филфак"
        case .ef:
            return "Эконом"
        case .uf:
            return "Юрист"
        }
    }
    
//    var dto: DepartmentDTO {
//        switch self {
//        case .bf:
//            return DepartmentDTO(fullName: "Биологический факультет", code: "bf")
//        case .gf:
//            return DepartmentDTO(fullName: "Географический факультет", code: "gf")
//        case .gl:
//            return DepartmentDTO(fullName: "Геологический факультет", code: "gl")
//        case .idpo:
//            return DepartmentDTO(fullName: "Институт дополнительного профессионального образования", code: "idpo")
//        case .ii:
//            return DepartmentDTO(fullName: "Институт искусств", code: "ii")
//        case .imo:
//            return DepartmentDTO(fullName: "Институт истории и международных отношений", code: "imo")
//        case .ff:
//            return DepartmentDTO(fullName: "Институт физики", code: "ff")
//        case .ifk:
//            return DepartmentDTO(fullName: "Институт физической культуры и спорта", code: "ifk")
//        case .ifg:
//            return DepartmentDTO(fullName: "Институт филологии и журналистики", code: "ifg")
//        case .ih:
//            return DepartmentDTO(fullName: "Институт химии", code: "ih")
//        case .mm:
//            return DepartmentDTO(fullName: "Механико-математический факультет", code: "mm")
//        case .sf:
//            return DepartmentDTO(fullName: "Социологический факультет", code: "sf")
//        case .fi:
//            return DepartmentDTO(fullName: "Факультет иностранных языков и лингводидактики", code: "fi")
//        case .knt:
//            return DepartmentDTO(fullName: "Факультет компьютерных наук и информационных технологий", code: "knt")
//        case .fps:
//            return DepartmentDTO(fullName: "Факультет психологии", code: "fps")
//        case .fppso:
//            return DepartmentDTO(fullName: "Факультет психолого-педагогического и специального образования", code: "fppso")
//        case .fmimt:
//            return DepartmentDTO(fullName: "Факультет фундаментальной медицины и медицинских технологий", code: "fmimt")
//        case .fp:
//            return DepartmentDTO(fullName: "Философский факультет", code: "fp")
//        case .ef:
//            return DepartmentDTO(fullName: "Экономический факультет", code: "ef")
//        case .uf:
//            return DepartmentDTO(fullName: "Юридический факультет", code: "uf")
//        }
//    }
    
    //    kgl
    //    cre
    //    bippf
    //    fmen
    //    biff
}
