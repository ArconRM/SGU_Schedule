//
//  LessonHTMLParserSGU.swift
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


struct LessonHTMLParserSGU: LessonHTMLParser {
    func getLessonsByDayNumberFromSource(source html: String, dayNumber: Int) throws -> [[Lesson]] {
        var result = [[Lesson]]()
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            var lesson: Lesson?
            
            for lessonNumber in 2...9 {
                var lessonsByNumber: [Lesson] = [] // массив, потому что те, что с подгруппами, будут под одним номером
                
                for divClassId1 in 0...15 { // подбор айдишника
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
        
        let subject = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Subject)
        let lectorName = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Lector)
        let cabinet = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Cabinet)
        let lessonType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .LessonType)
        let weekType = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .WeekType)
        let subgroup = getValueByXpathQuery(doc: doc, baseXpath: baseXpath, propertyEndpoint: .Subgroup)
        
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
    
    private func getValueByXpathQuery(doc: HTMLDocument, baseXpath: String, propertyEndpoint: LessonPropertiesEndpoints) -> String? {
        return doc.xpath(baseXpath + "/" + propertyEndpoint.rawValue).first?.text
    }
    
    
    
    func getLessonsOnCurrentWeekFromSource(source html: String) throws -> [[[Lesson]]] {
        var result = [[[Lesson]]]()
        
        for dayNumber in 1...6 {
            do {
                try result.append(getLessonsByDayNumberFromSource(source: html, dayNumber: dayNumber))
            }
            catch {
                throw NetworkError.HTMLParserError
            }
        }
        
        return result
    }    
}
