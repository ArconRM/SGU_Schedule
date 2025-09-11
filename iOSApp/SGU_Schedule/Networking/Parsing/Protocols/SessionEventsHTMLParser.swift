//
//  SessionEventsHTMLParser.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

protocol SessionEventsHTMLParser {
    func getSessionEventsFromSource(source html: String) throws -> [SessionEventDTO]
    func getGroupSessionEventsFromSource(source html: String, groupNumber: String, departmentCode: String) throws -> GroupSessionEventsDTO
}
