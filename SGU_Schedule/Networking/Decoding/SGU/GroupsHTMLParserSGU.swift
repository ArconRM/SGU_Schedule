//
//  GroupsHTMLParserSGU.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 22.08.2024.
//

import Foundation
import Kanna

//TODO: DepartmentParser
//case GroupName = "div[@class='accordion__wrap-title']/h3[@class='accordion__header accordion__header_color']"
//let baseXpath = "//div[@class='accordion__list'][\(DepartmentSource(rawValue: departmentCode)?.number ?? -1)]/div[@class='accordion-container']"


final class GroupsHTMLParserSGU: GroupsHTMLParser {
    func getGroupsByYearAndAcademicProgramFromSource (
        source html: String,
        year: Int,
        departmentCode: String,
        program: AcademicProgram
    ) throws -> [GroupDTO] {
        let doc = try HTML(html: html, encoding: .utf8)
        var baseXpath = "//div[@id='alias_\(departmentCode)']/div[@class='schedule__tab tab']/div[@class='tab__content tab__content_schedule']/div[@id='tab_\(departmentCode)-fulltime']/div[@class='schedule__group']/div[@class='schedule__group_wrap']"

        var result = [GroupDTO]()
        // Подбор нужной программы обучения и добавление в список
        for i in 1...4 {
            if let availableProgram = AcademicProgram(rawValue: doc.xpath(baseXpath + "[\(i)]/h3").first?.text ?? "") {
                if availableProgram == program {
                    let programXpath = baseXpath + "[\(i)]/ul[@class='schedule__group_list'][\(year)]/li[@class='schedule__group_item']"
                    result.append(contentsOf: doc.xpath(programXpath).map {
                        GroupDTO(fullNumber: Int($0.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "404") ?? 404)
                    })
                }
            }
        }
        return result
    }
}
