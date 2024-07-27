//
//  LessonHTMLParserSGU_old.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//
import Foundation
import Kanna


fileprivate enum LessonPropertiesEndpoints: String {
    case Subject = "div[@class='l-dn']"
    case Lector = "div[@class='l-tn']"
    case LectorUrl = "div[@class='l-tn']/a/@href"
    case Cabinet = "div[@class='l-p']"
    case LessonType = "div[@class='l-pr']/div[@class='l-pr-t']"
    case Subgroup = "div[@class='l-pr']/div[@class='l-pr-g']"
    case WeekType = "div[@class='l-pr']/div[@class='l-pr-r']"
}


struct LessonHTMLParserSGU_old: LessonHTMLParser {
    
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
//        do {
            let doc = try HTML(html: html, encoding: .utf8)
            var lesson: LessonDTO?
            
            for lessonNumber in 1...8 {
                for divClassId1 in 0...15 { // подбор айдишника
                    for divClassId2 in 0...15 {
                        lesson = decodeLesson(doc: doc,
                                              lessonNumber: lessonNumber,
                                              dayNumber: dayNumber,
                                              divClassId1: divClassId1,
                                              divClassId2: divClassId2)
                        if lesson != nil {
                            result.append(lesson!)
                        }
                    }
                }
            }
//        }
//        catch {
//            throw NetworkError.htmlParserError
//        }
        return result
    }
    
    private func decodeLesson(doc: HTMLDocument,
                              lessonNumber: Int,
                              dayNumber: Int,
                              divClassId1: Int,
                              divClassId2: Int) -> LessonDTO? {
        
        var divClass = "l l--t-5 " + "l--r-\(divClassId1) l--g-\(divClassId2)" // проверка лекции
        var baseXpath = "//td[@id='\(lessonNumber)_\(dayNumber)']/div[@class='\(divClass)']"
        
        if doc.xpath(baseXpath).first == nil {
            divClass = "l l--t-6 " + "l--r-\(divClassId1) l--g-\(divClassId2)" // проверка практики
            baseXpath = "//td[@id='\(lessonNumber)_\(dayNumber)']/div[@class='\(divClass)']"
            
            if doc.xpath(baseXpath).first == nil {
                return nil
            }
        }
        
        let xpathForLessonTime = "//table[@id='schedule']/tr[\(lessonNumber+1)]/th" // отдельно, потому что другой путь
        let lessonTimeXpathQueryResult = Array(doc.xpath(xpathForLessonTime).first?.text ?? "00:0000:00")
        let timeStart = String(lessonTimeXpathQueryResult[...4])
        let timeEnd = String(lessonTimeXpathQueryResult[5...])
        
        let subject = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Subject)
        let teacherName = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Lector)
        let teacherEndpoint = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .LectorUrl)
        let cabinet = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Cabinet)
        let lessonType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .LessonType)
        let weekType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .WeekType)
        let subgroup = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Subgroup)
        
        let lesson = LessonDTO(subject: subject ?? "Error",
                               teacherFullName: teacherName ?? "Error",
                               teacherEndpoint: teacherEndpoint,
                               lessonType: LessonType(rawValue: lessonType!) ?? .Lecture,
                               weekDay: Weekdays(dayNumber: dayNumber) ?? .Monday,
                               weekType: WeekType(rawValue: weekType!) ?? .All,
                               cabinet: cabinet ?? "Error",
                               subgroup: subgroup,
                               lessonNumber: lessonNumber,
                               timeStart: timeStart,
                               timeEnd: timeEnd)
        return lesson
    }
    
    private func getValueByXpathQuery(doc: HTMLDocument, baseXpath: String, propertyEndpoint: LessonPropertiesEndpoints) -> String? {
        return doc.xpath(baseXpath + "/" + propertyEndpoint.rawValue).first?.text
    }
}
