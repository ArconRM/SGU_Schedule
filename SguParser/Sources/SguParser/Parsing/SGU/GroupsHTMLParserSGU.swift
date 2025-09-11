//
//  GroupsHTMLParserSGU.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 22.08.2024.
//

import Foundation
import Kanna

// TODO: DepartmentParser
// case GroupName = "div[@class='accordion__wrap-title']/h3[@class='accordion__header accordion__header_color']"
// let baseXpath = "//div[@class='accordion__list'][\(DepartmentSource(rawValue: departmentCode)?.number ?? -1)]/div[@class='accordion-container']"

public final class GroupsHTMLParserSGU: GroupsHTMLParser {
    public init() {
        
    }
    
    public func getGroupsByYearAndAcademicProgramFromSource (
        source html: String,
        year: Int,
        departmentCode: String,
        program: AcademicProgram
    ) throws -> [AcademicGroupDTO] {

        let groupTypeRange = {
            switch program {
            case .bachelorAndSpeciality:
                [1, 2]
            case .masters:
                [3]
            case .postgraduate:
                [4]
            }
        }()

        var result = [AcademicGroupDTO]()
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            for groupTypeNumber in groupTypeRange {
                let xpathResult = doc.xpath("//li[@class='schedule-type__item'][\(groupTypeNumber)]/ul[@class='schedule-number__list']/li[@class='schedule-number__item'][\(year)]/a")
                guard xpathResult.count > 0 else {
                    continue
                }

                for i in 0...xpathResult.count-1 {
                    guard let fullNumber = Int(xpathResult[i].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") else {
                        continue
                    }
                    result.append(AcademicGroupDTO(fullNumber: String(fullNumber), departmentCode: departmentCode))
                }
            }
        } catch {
            throw NetworkError.htmlParserError
        }

        var seen = Set<AcademicGroupDTO>()
        return result.filter({ seen.insert($0).inserted })
    }
}
