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
    public func getTeacherFromSource(source html: String) throws -> TeacherDTO {
        throw NetworkError.htmlParserError
    }

    public func getAllTeacherSearchResultsFromSource(source html: String) throws -> Set<TeacherSearchResult> {
        let fixedHtml = html.replacingOccurrences(of: " id=\" alias_", with: "\" id=\"")
        let doc = try HTML(html: fixedHtml, encoding: .utf8)
        let teacherNameXpath = "//a[@class='schedule__fio_item-link']"
        let teacherEndpointXpath = "//a[@class='schedule__fio_item-link']/@href"

        var result = ThreadSafeSet<TeacherSearchResult>()

        let dispatchGroup = DispatchGroup()

        // 2482 на 30 октября 2024
        // 1576 на 12 ноября 2024
        // 1507 на 6 января 2025
        for i in 0...doc.xpath(teacherNameXpath).count-1 {

            dispatchGroup.enter()

            DispatchQueue.global().async {

                if let teacherName = doc.xpath(teacherNameXpath)[i].text,
                   let teacherLessonsEndpoint = doc.xpath(teacherEndpointXpath)[i].text {
                    result.insert(TeacherSearchResult(fullName: teacherName, lessonsUrlEndpoint: teacherLessonsEndpoint, sessionEventsUrlEndpoint: teacherLessonsEndpoint))
                }

                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()

        return result.getAllElements()
    }
}
