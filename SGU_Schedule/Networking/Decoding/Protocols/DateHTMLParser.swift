//
//  DateHTMLParser.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public protocol DateHTMLParser {
    func getLastUpdateDateFromSource(source html: String) throws -> Date
}
