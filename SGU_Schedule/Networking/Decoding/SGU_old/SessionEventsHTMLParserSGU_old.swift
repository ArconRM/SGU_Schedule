//
//  SessionEventsHTMLParserSGU_old.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation
import Kanna


struct SessionEventsHTMLParserSGU_old: SessionEventsHTMLParser {
    private let baseXpath = "//div[2]/table[@id='session']/"
    
    func getSessionEventsFromSource(source html: String) throws -> [SessionEventDTO] {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return sessionEvents
        }
        catch {
            throw NetworkError.htmlParserError
        }
    }
    
    func getGroupSessionEventsFromSource(source html: String, groupNumber: String, departmentCode: String) throws -> GroupSessionEventsDTO {
        do {
            let sessionEvents = try getSessionEventsByRowsFromSource(source: html)
            return GroupSessionEventsDTO(groupNumber: groupNumber, departmentCode: departmentCode, sessionEvents: sessionEvents)
        }
        catch {
            throw NetworkError.htmlParserError
        }
    }
    
    private func getSessionEventsByRowsFromSource(source html: String) throws -> [SessionEventDTO] {
        var sessionEvents = [SessionEventDTO]()
        let doc = try HTML(html: html, encoding: .utf8)
        
        for rowNumber in stride(from: 1, through: 100, by: 3) {
            let sessionEvent = decodeSessionEventByNumber(doc: doc, eventNumber: rowNumber)
            
            if sessionEvent != nil {
                sessionEvents.append(sessionEvent!)
            } else {
                break
            }
        }
        return sessionEvents
    }
    
    private func decodeSessionEventByNumber(doc: HTMLDocument, eventNumber baseId: Int) -> SessionEventDTO? {
        
        if doc.xpath(baseXpath + "tr[\(baseId)]").first == nil {
            return nil
        }
        
        let title = getValueByElementIds(doc: doc, trId: baseId, tdId: 4) ?? " Nothing"
        let sessionEventType = getValueByElementIds(doc: doc, trId: baseId, tdId: 3) ?? ""
        let teacherFullName = getValueByElementIds(doc: doc, trId: baseId+1, tdId: 2) ?? " Noone"
        let cabinet = getValueByElementIds(doc: doc, trId: baseId+2, tdId: 2) ?? " Nowhere"
        
        let date = getValueByElementIds(doc: doc, trId: baseId, tdId: 1)
        let time = getValueByElementIds(doc: doc, trId: baseId, tdId: 2)
        var fullDate = "01 января 2000 00:00"
        if date != nil && time != nil {
            fullDate = String(date!.dropLast(2)) + " " + time!
        }
        
        let sessionEvent = SessionEventDTO(title: String(title.dropFirst(1)),
                                           date: fullDate,
                                           sessionEventType: SessionEventType(rawValue: String(sessionEventType.dropLast())) ?? .Consultation,
                                           teacherFullName: String(teacherFullName.dropFirst(1)),
                                           cabinet: String(cabinet.dropFirst(1)))
        
        return sessionEvent
    }
    
    private func getValueByElementIds(doc: HTMLDocument, trId: Int, tdId: Int) -> String? {
        return doc.xpath(baseXpath + "tr[\(trId)]/td[\(tdId)]").first?.text
    }
}
