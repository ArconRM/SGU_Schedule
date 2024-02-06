//
//  SessionEventsHTMLParser.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import Foundation

public protocol SessionEventsHTMLParser {
    func getGroupSessionEventsFromSource(source html: String, groupNumber: Int) throws -> GroupSessionEventsDTO
}
