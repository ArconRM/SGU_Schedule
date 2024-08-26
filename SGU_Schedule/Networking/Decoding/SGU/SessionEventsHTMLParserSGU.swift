//
//  SessionEventsHTMLParserSGU.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 23.08.2024.
//

import Foundation
import Kanna

struct SessionEventsHTMLParserSGU: SessionEventsHTMLParser {
    private let baseXpath = "//div[@class='container']/table/tbody"
    
    func getSessionEventsFromSource(source html: String) throws -> [SessionEventDTO] {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return sessionEvents
        }
        catch {
            throw NetworkError.htmlParserError
        }
    }
    
    func getGroupSessionEventsFromSource(source html: String, groupNumber: Int) throws -> GroupSessionEventsDTO {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return GroupSessionEventsDTO(groupNumber: groupNumber, sessionEvents: sessionEvents)
        }
        catch {
            throw NetworkError.htmlParserError
        }
    }
    
    private func getSessionEventsByRowsFromSource(source html: String) throws -> [SessionEventDTO] {
        var sessionEvents = [SessionEventDTO]()
        let doc = try HTML(html: html, encoding: .utf8)
        let elements = doc.xpath(baseXpath)[1].text?
            .split(separator: "\n")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        if elements == nil {
            return []
        }
        
        for i in stride(from: 0, to: elements!.count, by: 5) {
            let date = String(elements![i].dropLast(2))
            let eventType = elements![i+1]
            let subject = elements![i+2]
            let teacher = elements![i+3]
            let cabinet = elements![i+4]
            
            sessionEvents.append(
                SessionEventDTO(
                    title: subject,
                    date: date, sessionEventType: SessionEventType(rawValue: eventType) ?? .Consultation,
                    teacherFullName: teacher,
                    cabinet: cabinet
                )
            )
        }
        
        return sessionEvents
    }
}
