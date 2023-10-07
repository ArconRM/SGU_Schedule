//
//  ScheduleHTMLEncoder.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.09.2023.
//


import Foundation
import Kanna


private enum LessonPropertiesEndpoints: String {
    case Subject = "div[@class='l-dn']"
    case Lector = "div[@class='l-tn']"
    case Cabinet = "div[@class='l-p']"
    case LessonType = "div[@class='l-pr']/div[@class='l-pr-t']"
    case Subgroup = "div[@class='l-pr']/div[@class='l-pr-g']"
    case WeekType = "div[@class='l-pr']/div[@class='l-pr-r']"
}


struct LessonHTMLParser {
    
    func getLessonsByWeekdayFromSource(source html: String, dayNumber: Int, isNumerator: Bool?) throws -> [[Lesson]] {
        var result = [[Lesson]]()
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            var lesson: Lesson?
            
            for lessonNumber in 2...9 {
                var lessonsByNumber: [Lesson] = [] // массив, потому что те, что с подгруппами, будут под одним номером
                
                for divClassId1 in 0...15 { // подбор айдишника, ToDo: мб можно изначально понять какие где
                    for divClassId2 in 0...15 {
                        lesson = decodeLessonFromString(doc: doc,
                                                        lessonNumber: lessonNumber,
                                                        dayNumber: dayNumber,
                                                        divClassId1: divClassId1,
                                                        divClassId2: divClassId2)
                        if lesson != nil {
                            lessonsByNumber.append(lesson!)
                        }
                    }
                }
                if !lessonsByNumber.isEmpty {
                    result.append(lessonsByNumber)
                }
            }
        }
        catch {
            throw NetworkError.HTMLParserError
        }
        return result
    }
    
    private func decodeLessonFromString(doc: HTMLDocument,
                                        lessonNumber: Int,
                                        dayNumber: Int,
                                        divClassId1: Int,
                                        divClassId2: Int) -> Lesson? {
        
        var divClass = "l l--t-5 " + "l--r-\(divClassId1) l--g-\(divClassId2)" // проверка лекции
        var baseXpath = "//td[@id='\(lessonNumber-1)_\(dayNumber)']/div[@class='\(divClass)']"
        
        if doc.xpath(baseXpath).first == nil {
            divClass = "l l--t-6 " + "l--r-\(divClassId1) l--g-\(divClassId2)" // проверка практики
            baseXpath = "//td[@id='\(lessonNumber-1)_\(dayNumber)']/div[@class='\(divClass)']"
            
            if doc.xpath(baseXpath).first == nil {
                return nil
            }
        }
        
        let xpathForLessonTime = "//table[@id='schedule']/tr[\(lessonNumber)]/th"
        let lessonTimeXpathQueryResult = Array(doc.xpath(xpathForLessonTime).first?.text ?? "00:0000:00")
        
        let timeStart = String(lessonTimeXpathQueryResult[...4])
        let timeEnd = String(lessonTimeXpathQueryResult[5...])
        
        let subject = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyType: .Subject)
        let lectorName = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyType: .Lector)
        let cabinet = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyType: .Cabinet)
        let lessonType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyType: .LessonType)
        let weekType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyType: .WeekType)
        let subgroup = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyType: .Subgroup)
        
        let lesson = Lesson(Subject: subject ?? "Error",
                            LectorFullName: lectorName ?? "Error",
                            TimeStart: timeStart,
                            TimeEnd: timeEnd,
                            LessonType: LessonType(rawValue: lessonType!) ?? .Lecture,
                            WeekType: WeekType(rawValue: weekType!) ?? .All,
                            Subgroup: subgroup,
                            Cabinet: cabinet ?? "Error")
        return lesson
    }
    
    private func getValueByXpathQuery(doc: HTMLDocument, baseXpath: String, propertyType: LessonPropertiesEndpoints) -> String? {
        return doc.xpath(baseXpath + "/" + propertyType.rawValue).first?.text
    }
    
    
    
    func getWeekLessonsFromSource(source html: String) throws -> [[[Lesson]]] {
        var result = [[[Lesson]]]()
        
        for dayNumber in 1...6 {
            do {
                try result.append(getLessonsByWeekdayFromSource(source: html, dayNumber: dayNumber, isNumerator: nil))
            }
            catch {
                throw NetworkError.HTMLParserError
            }
        }
        
        return result
    }
    
    func decodeLastUpdateDate(source html: String) throws -> Date {
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            let lastUpdateStr = String(doc.xpath("//div[@class='last-update']").first?.text?.dropFirst(22) ?? "01.01.2001")
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd'.'MM'.'yyyy'"
            let date = dateFormatter.date(from: lastUpdateStr)!
            
            return date
        }
        catch {
            throw NetworkError.HTMLParserError
        }
    }
    
}
