//
//  LessonHTMLParserSGU.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 20.08.2024.
//

import Foundation
import Kanna


fileprivate enum LessonPropertiesEndpoints: String {
    case Subject = "div[@class='schedule-table__lesson-name']"
    case Teacher = "div[@class='schedule-table__lesson-teacher']"
    case TeacherUrl = "div[@class='l-tn']/a/@href"
    case Cabinet = "div[@class='schedule-table__lesson-room']/span"
    case LessonType = "div[@class='schedule-table__lesson-props']"
    case Subgroup = "div[@class='schedule-table__lesson-uncertain']"
    case WeekType = "div[@class='lesson-prop__num']"
}


struct LessonHTMLParserSGU: LessonHTMLParser {
    func getScheduleFromSource(source html: String) throws -> [LessonDTO] {
        do {
            let lessonsByDays = try getLessonsByDaysFromSource(source: html)
            return lessonsByDays
        }
        catch {
            throw NetworkError.htmlParserError
        }
    }
    
    func getGroupScheduleFromSource(source html: String, groupNumber: Int) throws -> GroupScheduleDTO {
        do {
            let lessonsByDays = try getLessonsByDaysFromSource(source: html)
            return GroupScheduleDTO(groupNumber: groupNumber, lessonsByDays: lessonsByDays)
        }
        catch {
            throw NetworkError.htmlParserError
        }
    }
    
    private func getLessonsByDaysFromSource(source html: String) throws -> [LessonDTO] {
        var lessonsByDays = [LessonDTO]()
        
        for dayNumber in 1...6 {
            try lessonsByDays.append(contentsOf: getLessonsByDayNumberFromSource(source: html, dayNumber: dayNumber))
        }
        
        return lessonsByDays
    }
    
    private func getLessonsByDayNumberFromSource(source html: String, dayNumber: Int) throws -> [LessonDTO] {
        var result = [LessonDTO]()
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            var lessons: [LessonDTO]
            
            for lessonNumber in 1...8 {
                lessons = decodeLessonsByNumber(doc: doc, lessonNumber: lessonNumber, dayNumber: dayNumber)
                result.append(contentsOf: lessons)
            }
        }
        catch {
            throw NetworkError.htmlParserError
        }
        return result
    }
    
    private func decodeLessonsByNumber(doc: HTMLDocument, lessonNumber: Int, dayNumber: Int) -> [LessonDTO] {
        
        var baseXpath = "//tbody/tr[\(lessonNumber)]/td[@class='schedule-table__col _active-col'][\(dayNumber)]/div[@class='schedule-table__lesson']"
        
        if doc.xpath(baseXpath).first == nil {
            baseXpath = "//tbody/tr[\(lessonNumber)]/td[@class='schedule-table__col'][\(dayNumber-2)]/div[@class='schedule-table__lesson']"
            if doc.xpath(baseXpath).first == nil {
                return []
            }
        }
        
        let xpathForLessonTime = "//tbody/tr[\(lessonNumber)]/th/div[@class='schedule-table__header']" // отдельно, потому что другой путь
        let lessonTimeXpathQueryResult = String(doc.xpath(xpathForLessonTime).first?.text?.filter { !" \n\t\r".contains($0) } ?? "00:0000:00")
        let timeStart = String(lessonTimeXpathQueryResult.prefix(5))
        let timeEnd = String(lessonTimeXpathQueryResult.suffix(5))
        
        // Идем по всем парам, которые могут быть (максимум (?) 10)
        var result: [LessonDTO] = []
        for i in 1...10 {
            let xpathForInnerNumber = baseXpath + "[\(i)]"
            if doc.xpath(baseXpath + "[\(i)]").first?.text == nil {
                continue
            }
            
            let subject = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Subject)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let teacherName = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Teacher)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let teacherEndpoint = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .TeacherUrl)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let cabinet = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Cabinet)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lessonType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .LessonType)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let weekType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .WeekType)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let subgroup = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Subgroup)?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let lesson = LessonDTO(subject: subject ?? "Error",
                                   teacherFullName: teacherName ?? "Error",
                                   teacherEndpoint: teacherEndpoint,
                                   lessonType: LessonType(rawValue: lessonType ?? "") ?? .Lecture,
                                   weekDay: Weekdays(dayNumber: dayNumber) ?? .Monday,
                                   weekType: WeekType(rawValue: weekType ?? "") ?? .All,
                                   cabinet: cabinet ?? "Error",
                                   subgroup: subgroup,
                                   lessonNumber: lessonNumber,
                                   timeStart: timeStart,
                                   timeEnd: timeEnd)
            result.append(lesson)
        }
        return result
    }
    
//    private func insertNumberInBaseXpath(baseXpath: String, number: Int) -> String {
//        return baseXpath.split(separator: "/").dropLast().joined() + "/[\(number)]/" + (baseXpath.split(separator: "/").last ?? "")
//    }
    
    private func getValueByXpathQuery(doc: HTMLDocument, baseXpath: String, propertyEndpoint: LessonPropertiesEndpoints) -> String? {
        return doc.xpath(baseXpath + "/" + propertyEndpoint.rawValue).first?.text
    }
}
