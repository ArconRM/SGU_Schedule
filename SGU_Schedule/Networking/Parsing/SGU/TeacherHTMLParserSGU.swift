//
//  TeacherHTMLParserSGU.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 28.10.2024.
//

import Foundation
import Kanna

public struct TeacherHTMLParserSGU: TeacherHTMLParser {
    /// Not implemented
    public func getTeacherFromSource(source html: String) throws -> Teacher {
        throw NetworkError.htmlParserError
    }

    public func getAllTeachersDTOFromSource(source html: String) throws -> Set<TeacherSearchResult> {
        let fixedHtml = html.replacingOccurrences(of: " id=\" alias_", with: "\" id=\"")
        let doc = try HTML(html: fixedHtml, encoding: .utf8)
        let teacherNameXpath = "//a[@class='schedule__fio_item-link']"
        let teacherEndpointXpath = "//a[@class='schedule__fio_item-link']/@href"
//        let teacherDepartmentXpath = "//a[@class='schedule__faculty_item-link']"

        var result = Set<TeacherSearchResult>()

        // 2482 на 30 октября 2024
        // 1576 на 12 ноября 2024
        for i in 0...doc.xpath(teacherNameXpath).count-1 {
            if let teacherName = doc.xpath(teacherNameXpath)[i].text,
               let teacherLessonsEndpoint = doc.xpath(teacherEndpointXpath)[i].text {
                result.insert(TeacherSearchResult(fullName: teacherName, lessonsUrlEndpoint: teacherLessonsEndpoint, sessionEventsUrlEndpoint: teacherLessonsEndpoint))
            }
        }

        return result
    }
}
