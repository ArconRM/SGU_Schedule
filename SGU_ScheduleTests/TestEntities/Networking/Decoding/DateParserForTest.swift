//
//  DateParserForTest.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class DateParserForTest: DateHTMLParser {
    func getLastUpdateDateFromSource(source html: String) throws -> Date {
        return Date()
    }
}
