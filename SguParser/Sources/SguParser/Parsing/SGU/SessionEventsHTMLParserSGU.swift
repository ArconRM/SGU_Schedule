//
//  SessionEventsHTMLParserSGU.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 23.08.2024.
//

import Foundation
import Kanna

private enum SessionEventPropertiesEndpoints: String {
    case title = "td[2]/p[@class='schedule-discipline']"
    case date = "td[1]"
    case sessionEventType = "td[2]/p[@class='schedule-form']"
    case teacherFullName = "td[3]"
    case cabinet = "td[4]"
}

public struct SessionEventsHTMLParserSGU: SessionEventsHTMLParser {
    public init() {
        
    }
    
    private let baseXpath = "//div[@class='schedule__choose schedule__wrap-lection _active-wrap']/div[@class='container']/table/tbody"

    public func getSessionEventsFromSource(source html: String) throws -> [SessionEventDTO] {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return sessionEvents
        } catch {
            throw NetworkError.htmlParserError
        }
    }

    public func getGroupSessionEventsFromSource(source html: String, groupNumber: String, departmentCode: String) throws -> GroupSessionEventsDTO {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return GroupSessionEventsDTO(groupNumber: groupNumber, departmentCode: departmentCode, sessionEvents: sessionEvents)
        } catch {
            throw NetworkError.htmlParserError
        }
    }

    private func getSessionEventsByRowsFromSource(source html: String) throws -> [SessionEventDTO] {
        let doc = try HTML(html: html, encoding: .utf8)

        // Нормальный способ, но нахуевертили в верстке и это не для всех работает 😐
//        for i in 1...doc.xpath(baseXpath + "/tr[1]").count {
//            let xpathForInnerNumber = baseXpath + "/tr[\(i)]"
//
//            let title = getValueByXpathQuery(doc: doc, baseXpath: xpathForInnerNumber, propertyEndpoint: .title)?
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//
//            let sessionEventType = getValueByXpathQuery(doc: doc, baseXpath: xpathForInnerNumber, propertyEndpoint: .sessionEventType)?
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//
//            let room = getValueByXpathQuery(doc: doc, baseXpath: xpathForInnerNumber, propertyEndpoint: .sessionEventType)?
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//
//            let date = getValueByXpathQuery(doc: doc, baseXpath: xpathForInnerNumber, propertyEndpoint: .date)?
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//                .replacingOccurrences(of: "г. ", with: "")
//
//            let teacherFullName = getValueByXpathQuery(doc: doc, baseXpath: xpathForInnerNumber, propertyEndpoint: .teacherFullName)?
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//
//            sessionEvents.append(
//                SessionEventDTO(
//                    title: title ?? "Error",
//                    date: date ?? "",
//                    sessionEventType: SessionEventType(rawValue: sessionEventType ?? "") ?? .exam,
//                    teacherFullName: teacherFullName ?? "Error",
//                    cabinet: room ?? "Error"
//                )
//            )
//        }

        // Всратый способ, но вроде для всех работает
        guard doc.xpath(baseXpath).count > 0 else {
            return []
        }
        let elements = doc.xpath(baseXpath)[doc.xpath(baseXpath).count - 1].text?
            .split(separator: "\n")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        if elements == nil {
            return []
        }

        var sessionEvents: [SessionEventDTO] = []
        var i = 0

        while i < elements!.count {
            if elements![i] == "Заочная форма обучения" {
                i += 1
                continue
            }
            
            guard i + 4 < elements!.count else { break }
            
            let dateString = elements![i]
            if !dateString.contains("20") || !dateString.contains(":") {
                i += 1
                continue
            }
            
            let date = dateString
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "г. ", with: "")
            let eventType = elements![i + 1]
            let subject = elements![i + 2]
            let teacher = elements![i + 3]
            let cabinet = elements![i + 4]
            
            i += 5  // Сначала сдвигаемся
            
            // Теперь проверяем подгруппу ПОСЛЕ основных полей
            var subgroup: String? = nil
            if i < elements!.count &&
               elements![i].hasPrefix("(") &&
               elements![i].hasSuffix("под)") {
                subgroup = elements![i]
                i += 1  // Пропускаем подгруппу
            }
            
            var finalSubject = subject
            if let sub = subgroup {
                finalSubject = "\(subject) \(sub)"
            }
            
            sessionEvents.append(
                SessionEventDTO(
                    title: finalSubject,
                    date: date,
                    sessionEventType: SessionEventType(rawValue: eventType) ?? .exam,
                    teacherFullName: teacher,
                    cabinet: cabinet
                )
            )
        }

        return sessionEvents
    }

    private func getValueByXpathQuery(doc: HTMLDocument, baseXpath: String, propertyEndpoint: SessionEventPropertiesEndpoints) -> String? {
        return doc.xpath(baseXpath + "/" + propertyEndpoint.rawValue).first?.text
    }
}
