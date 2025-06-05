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

struct SessionEventsHTMLParserSGU: SessionEventsHTMLParser {
    private let baseXpath = "//div[@class='dialog-off-canvas-main-canvas']/main[@class='main']//div[@class='region region-content']/div[@class='block block-system block-system-main-block']/div[@class='schedule__choose schedule__wrap-session']/div[@class='container']/table/tbody"

    func getSessionEventsFromSource(source html: String) throws -> [SessionEventDTO] {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return sessionEvents
        } catch {
            throw NetworkError.htmlParserError
        }
    }

    func getGroupSessionEventsFromSource(source html: String, groupNumber: String, departmentCode: String) throws -> GroupSessionEventsDTO {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return GroupSessionEventsDTO(groupNumber: groupNumber, departmentCode: departmentCode, sessionEvents: sessionEvents)
        } catch {
            throw NetworkError.htmlParserError
        }
    }

    private func getSessionEventsByRowsFromSource(source html: String) throws -> [SessionEventDTO] {
        var sessionEvents = [SessionEventDTO]()
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

        let containsGroupType = elements!.count % 5 == 0

        for i in stride(from: 0, to: elements!.count, by: containsGroupType ? 5 : 6) {
            let date = elements![i]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "г. ", with: "")
            let eventType = elements![i + 1]
            let subject = elements![i + 2]
            let group = elements![i + 3]
            let cabinet = elements![i + (containsGroupType ? 4 : 5)]

            sessionEvents.append(
                SessionEventDTO(
                    title: subject,
                    date: date,
                    sessionEventType: SessionEventType(rawValue: eventType) ?? .exam,
                    teacherFullName: group,
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
