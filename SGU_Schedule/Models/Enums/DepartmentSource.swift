//
//  DepartmentSource.swift
//  SGU_Schedule
//
//  Created by Артемий on 08.02.2024.
//

import Foundation

public enum DepartmentSource: String, CaseIterable {
    case bf
    case gf
    case gl
    case idpo
    case imo
    case ff
    case ifg
    case ih
    case mm
    case sf
    case gdrin
    case piii
    case fi
    case knt
    case fps
    case fppso
    case fmend
    case piifk
    case fmimt
    case fp
    case ef
    case uf

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
        case .imo:
            return "Институт истории и международных отношений"
        case .ff:
            return "Институт физики"
        case .ifg:
            return "Институт филологии и журналистики"
        case .ih:
            return "Институт химии"
        case .mm:
            return "Механико-математический факультет"
        case .sf:
            return "Социологический факультет"
        case .gdrin:
            return "Факультет гуманитарных дисциплин, русского и иностранных языков"
        case .piii:
            return "Факультет искусств"
        case .fi:
            return "Факультет иностранных языков и лингводидактики"
        case .knt:
            return "Факультет компьютерных наук и информационных технологий"
        case .fps:
            return "Факультет психологии"
        case .fppso:
            return "Факультет психолого-педагогического и специального образования"
        case .fmend:
            return "Факультет физико-математических и естественно-научных дисциплин"
        case .piifk:
            return "Факультет физической культуры и спорта"
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
        case .imo:
            return "ИМО"
        case .ff:
            return "Физ"
        case .ifg:
            return "ФилЖур"
        case .ih:
            return "Хим"
        case .mm:
            return "МехМат"
        case .sf:
            return "Социо"
        case .gdrin:
            return "ГДРЯиИН"
        case .piii:
            return "Искусств"
        case .fi:
            return "Иностр"
        case .knt:
            return "КНИИТ"
        case .fps:
            return "Психолог"
        case .fppso:
            return "ППиСО"
        case .fmend:
            return "ФФМиЕНД"
        case .piifk:
            return "ФизКульт"
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

    init?(fullName: String) {
        switch fullName {
        case DepartmentSource.bf.fullName: self = .bf
        case DepartmentSource.gf.fullName: self = .gf
        case DepartmentSource.gl.fullName: self = .gl
        case DepartmentSource.idpo.fullName: self = .idpo
        case DepartmentSource.imo.fullName: self = .imo
        case DepartmentSource.ff.fullName: self = .ff
        case DepartmentSource.ifg.fullName: self = .ifg
        case DepartmentSource.ih.fullName: self = .ih
        case DepartmentSource.mm.fullName: self = .mm
        case DepartmentSource.sf.fullName: self = .sf
        case DepartmentSource.gdrin.fullName: self = .gdrin
        case DepartmentSource.piii.fullName: self = .piii
        case DepartmentSource.fi.fullName: self = .fi
        case DepartmentSource.knt.fullName: self = .knt
        case DepartmentSource.fps.fullName: self = .fps

        case DepartmentSource.fppso.fullName: self = .fppso
        case DepartmentSource.fmend.fullName: self = .fmend
        case DepartmentSource.piifk.fullName: self = .piifk
        case DepartmentSource.fmimt.fullName: self = .fmimt
        case DepartmentSource.fp.fullName: self = .fp
        case DepartmentSource.ef.fullName: self = .ef
        case DepartmentSource.uf.fullName: self = .uf
        default: return nil
        }
    }

    init?(shortName: String) {
        switch shortName {
        case DepartmentSource.bf.shortName: self = .bf
        case DepartmentSource.gf.shortName: self = .gf
        case DepartmentSource.gl.shortName: self = .gl
        case DepartmentSource.idpo.shortName: self = .idpo
        case DepartmentSource.imo.shortName: self = .imo
        case DepartmentSource.ff.shortName: self = .ff
        case DepartmentSource.ifg.shortName: self = .ifg
        case DepartmentSource.ih.shortName: self = .ih
        case DepartmentSource.mm.shortName: self = .mm
        case DepartmentSource.sf.shortName: self = .sf
        case DepartmentSource.gdrin.shortName: self = .gdrin
        case DepartmentSource.piii.shortName: self = .piii
        case DepartmentSource.fi.shortName: self = .fi
        case DepartmentSource.knt.shortName: self = .knt
        case DepartmentSource.fps.shortName: self = .fps

        case DepartmentSource.fppso.shortName: self = .fppso
        case DepartmentSource.fmend.shortName: self = .fmend
        case DepartmentSource.piifk.shortName: self = .piifk
        case DepartmentSource.fmimt.shortName: self = .fmimt
        case DepartmentSource.fp.shortName: self = .fp
        case DepartmentSource.ef.shortName: self = .ef
        case DepartmentSource.uf.shortName: self = .uf
        default: return nil
        }
    }

    //    var dto: Department {
    //        switch self {
    //        case .bf:
    //            return Department(fullName: "Биологический факультет", code: "bf")
    //        case .gf:
    //            return Department(fullName: "Географический факультет", code: "gf")
    //        case .gl:
    //            return Department(fullName: "Геологический факультет", code: "gl")
    //        case .idpo:
    //            return Department(fullName: "Институт дополнительного профессионального образования", code: "idpo")
    //        case .ii:
    //            return Department(fullName: "Институт искусств", code: "ii")
    //        case .imo:
    //            return Department(fullName: "Институт истории и международных отношений", code: "imo")
    //        case .ff:
    //            return Department(fullName: "Институт физики", code: "ff")
    //        case .ifk:
    //            return Department(fullName: "Институт физической культуры и спорта", code: "ifk")
    //        case .ifg:
    //            return Department(fullName: "Институт филологии и журналистики", code: "ifg")
    //        case .ih:
    //            return Department(fullName: "Институт химии", code: "ih")
    //        case .mm:
    //            return Department(fullName: "Механико-математический факультет", code: "mm")
    //        case .sf:
    //            return Department(fullName: "Социологический факультет", code: "sf")
    //        case .fi:
    //            return Department(fullName: "Факультет иностранных языков и лингводидактики", code: "fi")
    //        case .knt:
    //            return Department(fullName: "Факультет компьютерных наук и информационных технологий", code: "knt")
    //        case .fps:
    //            return Department(fullName: "Факультет психологии", code: "fps")
    //        case .fppso:
    //            return Department(fullName: "Факультет психолого-педагогического и специального образования", code: "fppso")
    //        case .fmimt:
    //            return Department(fullName: "Факультет фундаментальной медицины и медицинских технологий", code: "fmimt")
    //        case .fp:
    //            return Department(fullName: "Философский факультет", code: "fp")
    //        case .ef:
    //            return Department(fullName: "Экономический факультет", code: "ef")
    //        case .uf:
    //            return Department(fullName: "Юридический факультет", code: "uf")
    //        }
    //    }

    //    kgl
    //    cre
    //    bippf
    //    fmen
    //    biff
}
