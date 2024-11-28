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

final class GroupsHTMLParserSGU: GroupsHTMLParser {
    func getGroupsByYearAndAcademicProgramFromSource (
        source html: String,
        year: Int,
        departmentCode: String,
        program: AcademicProgram
    ) throws -> [AcademicGroupDTO] {
        let fixedHtml = html.replacingOccurrences(of: " id=\" alias_", with: "\" id=\"")
        let doc = try HTML(html: fixedHtml, encoding: .utf8)

        // //div[@class='accordion__list'][13]/div[@class='accordion-container']/div[@class='accordion__content']/div[@id='\(departmentCode)']/div[@class='schedule__form-education    schedule__form-education_do _active-form-schedule']/li[@class='schedule-type__item'][1]/ul[@class='schedule-number__list']/li[@class='schedule-number__item'][1]/a[1]

        let baseXpath = "//div[@class='accordion-container']/div[@class='accordion__content']/div[@id='\(departmentCode)']/div[@class='schedule__form-education    schedule__form-education_do _active-form-schedule']/li[@class='schedule-type__item']"
        var result = [AcademicGroupDTO]()

        //        po doc.at_css("ul.schedule__wrap_fio")?.content.split("\n")
        // ul[@class='schedule__wrap_fio']/\(i)/a[@class='schedule__fio_item-link']
        // //li[@class='schedule__fio_item fio-show'][1]/a[@class='schedule__fio_item-link']/@href

        // Подбор нужной программы обучения и добавление в список
        for i in 1...4 {
            if let curAcademicProgram = AcademicProgram(rawValue: doc.xpath(baseXpath + "[\(i)]/span").first?.text ?? "error") {
                if curAcademicProgram == program {
                    let programXpath = baseXpath + "[\(i)]/ul[@class='schedule-number__list']"
                    if let programYears = doc.xpath(programXpath).first {
                        for child in programYears.xpath("./*") {
                            if child.text != nil && child.text!.contains("\(year) курс") {
                                for groupNumber in child.text!.replacingOccurrences(of: " ", with: "").split(separator: "\n").dropFirst() {
                                    result.append(AcademicGroupDTO(fullNumber: String(groupNumber), departmentCode: departmentCode))
                                }
                            }
                        }
                    }
                }
            }
        }
        return result
    }
}
